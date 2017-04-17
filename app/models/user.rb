class User < ApplicationRecord
	scope :current_level, -> { Character.where(level: self.order(level: :desc).first[:level]) }

	def self.current_user
		first || new
	end
	def self.update_attributes
		body = WanikaniApi.new.get("level-progression")
		user = body['requested_information'].merge(body['user_information'])
		user['creation_date'] = Time.at(user['creation_date']).to_datetime
		user.select!{|x| attribute_names.index(x) != nil}
		current_user.update_attributes user
	end
end
