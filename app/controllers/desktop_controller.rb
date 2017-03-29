class DesktopController < ApplicationController
	add_breadcrumb 'Desktop', 'desktop_path'
	def index
		@user_level = Character.order(level: :desc).first[:level] - 1
		@last_update = Log.order(created_at: :desc).first[:created_at]

		# TODO: move api request to a separate service
		# TODO: store user info as an entity
		apiKey = ENV['WANIKANI_API_KEY']
		response = RestClient.get("https://www.wanikani.com/api/user/#{apiKey}/level-progression/")
		@progress = (JSON.parse response.body)['requested_information']
		%w(radicals kanji).each do |type|
			@progress["#{type}_percent"] = @progress["#{type}_progress"].to_f / @progress["#{type}_total"].to_f
		end
	end
end
