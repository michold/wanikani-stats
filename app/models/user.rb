class User < ApplicationRecord
	def self.current_user
		first || new
	end
	def self.update_attributes
		apiKey = ENV['WANIKANI_API_KEY']
		response = RestClient.get("https://www.wanikani.com/api/user/#{apiKey}/level-progression/")
		body = JSON.parse response.body
		user = body['requested_information'].merge(body['user_information'])
		user['creation_date'] = Time.at(user['creation_date']).to_datetime
		user.select!{|x| attribute_names.index(x) != nil}
		current_user.update_attributes user
	end
end
