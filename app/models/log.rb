class Log < ActiveRecord::Base
	belongs_to :character 

    scope :reviews, -> { where(is_review: true) } 
    scope :lessons, -> { where(is_review: false) } 

	def self.last_update
		order(:created_at).last.created_at
	end
	def self.load_new_logs
		# TODO: make the api calls async
		blacklist = ['user_synonyms']
		wanikaniApi = WanikaniApi.new
		characters = Character.all
		# apparently running a query for each find is faster than .find{|x| x == y} on a loaded collection
		# logs = Log.order('created_at DESC')
		{'radicals' => Radical, 'kanji' => Kanji, 'vocabulary' => Vocabulary}.each do |type, characterClass|
			logsToSave = []
			items = wanikaniApi.get(type)['requested_information']
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
				create_new_character = false

				character = characterClass.find_by_character_and_image(item['character'], item['image'])
				# character = characters.find{|x| x[:type] == characterClass && x[:character] == item['character'] && x[:image] == item['image']}
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
				# oldLog = logs.find{|x| x[:character_id] == character.id}
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
	end
end
