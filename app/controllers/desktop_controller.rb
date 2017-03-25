class DesktopController < ApplicationController
	def index
		@recentLogs = Log.where("created_at >= ?", 1.week.ago.utc).order(created_at: :desc)
		@recentCharacters = Character.where("created_at >= ?", 11.days.ago.utc).order(created_at: :desc)
	end
end
