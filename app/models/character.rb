class Character < ActiveRecord::Base 
    has_many :logs, :dependent => :destroy
    self.inheritance_column = :type 

    def self.types
      %w(Radical Kanji Vocabulary)
    end

    scope :radicals, -> { where(type: 'Radical') } 
    scope :kanjis, -> { where(type: 'Kanji') } 
    scope :vocabularies, -> { where(type: 'Vocabulary') }

    scope :current_level, -> { where(level: self.order(level: :desc).first[:level]) }

    def current_log
    	self.logs.order("created_at").last
    end
end