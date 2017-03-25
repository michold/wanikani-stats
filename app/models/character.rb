class Character < ActiveRecord::Base 
    has_many :logs 
    self.inheritance_column = :type 

    def self.types
      %w(Radical Kanji Vocabulary)
    end

    scope :radicals, -> { where(type: 'Radical') } 
    scope :kanjis, -> { where(type: 'Kanji') } 
    scope :vocabularies, -> { where(type: 'Vocabulary') }

    def self.cached_list
        @cached_list ||= self.all
    end
    def self.find_one_in_cache (params)
        all = self.cached_list
        all.each do |character|
            found = true
            params.each do |key, value|
                if character[key] != value
                    found = false
                    break
                end
            end
            return character if found
        end
    end
    def current_log
    	self.logs.order("created_at").last
    end
end