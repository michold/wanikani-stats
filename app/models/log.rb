class Log < ActiveRecord::Base
	RESPONSE_LOG_BLACKLIST = %w(user_synonyms)
	RESPONSE_CHARACTER_BLACKLIST = %w(image_file_name image_content_type image_file_size)
	belongs_to :character, :counter_cache => true

  scope :reviews, -> { where(is_review: true) } 
  scope :lessons, -> { where(is_review: false) } 

	def prev_log
		character
			.logs
			.where("created_at < ?", created_at)
			.order(created_at: :desc)
			.first
	end

	def correct
		prev = prev_log || NullLog
		prev.srs_numeric <= srs_numeric
	end

	class << self
		def last_update
			# max(:created_at) 
			order(:created_at).last.created_at
		end

		def last_character_logs
			joins("
				INNER JOIN (
					SELECT character_id, MAX(created_at) as max_ca 
					FROM logs 
					GROUP BY character_id
				) as distinct_logs 
				ON logs.character_id = distinct_logs.character_id AND logs.created_at = distinct_logs.max_ca
				")
		end

		def get_correct_percentage(logs)
			correct_count = 0
			new_item_count = 0
			logs.each do |log|
				correct = log.correct
				if correct.nil?
					new_item_count += 1
				elsif correct
					correct_count += 1
				end
			end
			logs_count = logs.count - new_item_count

			(correct_count.to_f / logs_count * 100).round(2)
		end

		def load_new_logs
			wanikaniApi = WanikaniApi.new
			# apparently running a query for each find is faster than .find{|x| x == y} on a loaded collection

			urls = {'radicals' => Radical, 'kanji' => Kanji, 'vocabulary' => Vocabulary}

			pending = urls.size

			EventMachine.run do
			  urls.each do |type, characterClass|
			  	http = EventMachine::HttpRequest.new(wanikaniApi.get_url(type), :connect_timeout => 325).get
			    http.callback {
			    	handle_request(http.response, type, characterClass)

			      pending -= 1
			      EventMachine.stop if pending < 1
			    }
			    http.errback {
			      logger.debug "error loading #{type} #{http.error}"

			      pending -= 1
			      EventMachine.stop if pending < 1
			    }
			  end
			end
		end

		private

		def handle_request(response, type, characterClass)
			logsToSave = []
			items = response_items(response, type)
			items.each do |item| 
				log = item.delete('user_specific')
				next if log.nil?
				RESPONSE_LOG_BLACKLIST.each do |field|
					log.delete(field)
				end
				log = map_date_values(log)

				create_new_log = false

				character = characterClass.find_by_character_and_image(item['character'], item['image'])
				if character.nil?
					character = create_new_character(item.clone, characterClass)
					create_new_log = true
					log['is_review'] = false
				end

				oldLog = order('created_at DESC').find_by_character_id(character.id)
				if !oldLog.nil?
					oldLog.attributes = log
					if oldLog.changed.count > 0
						logger.debug "attr changed for #{oldLog.character}:"
						logger.debug oldLog.changed
						create_new_log = true
					end
				end
				if create_new_log
					logger.debug "create new log for #{item['character']}"	
					log['character'] = character
					logsToSave << log
				end
			end
			logger.debug "All #{type} logs are up to date." if logsToSave.empty?
			create(logsToSave)
		end

		def response_items(response, type)
			items = JSON.parse(response)['requested_information'] # maybe make it faster somehow?
			if type == 'vocabulary'
				items = items['general']
			end
			items
		end

		def map_date_values(log)
			log.each do |field, value|
				if field.end_with? "_date"
					if value == 0
						log[field] = nil
					else
						log[field] = Time.at(value).to_datetime
					end
				end
			end
			log
		end

		def create_new_character(character_attrs, characterClass)
			RESPONSE_CHARACTER_BLACKLIST.each do |field|
				character_attrs.delete(field)
			end
			character = characterClass.create(character_attrs)
			logger.debug '...................'
			logger.debug 'loading new character:'
			logger.debug character_attrs['character']
			logger.debug '...................'
			character
		end
	end
end
