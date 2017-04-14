class Log < ActiveRecord::Base
	belongs_to :character 

  scope :reviews, -> { where(is_review: true) } 
  scope :lessons, -> { where(is_review: false) } 

	def self.last_update
		order(:created_at).last.created_at
	end
	def self.last_character_logs
		self.joins("
			INNER JOIN (
				SELECT character_id, MAX(created_at) as max_ca 
				FROM logs 
				GROUP BY character_id
			) as distinct_logs 
			ON logs.character_id = distinct_logs.character_id AND logs.created_at = distinct_logs.max_ca
			")
	end
	def prev_log
		Log.where({:character => self.character_id}).where("created_at < ?", self.created_at).order(:created_at => :desc).first
	end
	def correct
		prev = self.prev_log
		prev.nil? ? nil : prev[:srs_numeric] <= self[:srs_numeric]
	end
	def self.get_correct_percentage(logs)
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
	def self.load_new_logs
		blacklist = ['user_synonyms']
		wanikaniApi = WanikaniApi.new
		# apparently running a query for each find is faster than .find{|x| x == y} on a loaded collection

		urls = {'radicals' => Radical, 'kanji' => Kanji, 'vocabulary' => Vocabulary}

		pending = urls.size

		EventMachine.run do
		  urls.each do |type, characterClass|
		  	http = EventMachine::HttpRequest.new(wanikaniApi.get_url(type), :connect_timeout => 325).get
		    http.callback {
	    		logsToSave = []
	    		items = (JSON.parse http.response)['requested_information']
	    		if type == 'vocabulary'
	    			items = items['general']
	    		end
	    		items.each do |item| 
	    			log = item['user_specific']
	    			next if log.nil?
	    			blacklist.each do |field|
	    				log.delete(field)
	    			end
	    			log.each do |field, value|
	    				if field.end_with? "_date"
	    					if value == 0
	    						log[field] = nil
	    					else
	    						log[field] = Time.at(value).to_datetime
	    					end
	    				end
	    			end

	    			create_new_log = false

	    			character = characterClass.find_by_character_and_image(item['character'], item['image'])
	    			if character.nil?
	    				characterItem = item.clone
	    				characterItem.delete('user_specific')
	    				character = characterClass.create(characterItem)
	    				create_new_log = true
	    				log['is_review'] = false
	    				logger.debug '...................'
	    				logger.debug 'loading new character:'
	    				logger.debug item['character']
	    				logger.debug '...................'
	    			end

	    			oldLog = self.order('created_at DESC').find_by_character_id(character.id)
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
end
