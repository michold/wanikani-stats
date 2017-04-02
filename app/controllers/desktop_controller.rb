class DesktopController < ApplicationController
	add_breadcrumb 'Desktop', 'desktop_path'
	def index
		@last_update = Log.order(created_at: :desc).first[:created_at]

		@user = User.current_user
		@progress = {}
		%w(radicals kanji).each do |type|
			@progress["#{type}_percent"] = @user["#{type}_progress"].to_f / @user["#{type}_total"].to_f * 100
		end
	end
end
