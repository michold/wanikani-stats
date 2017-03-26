class DesktopController < ApplicationController
	add_breadcrumb 'Desktop', 'desktop_path'
	def index
		@logs_chart = [
	    {
	      name: "reviews", data: Log.reviews.group_by_day(:created_at, last: 8).count
	    }, {
	      name: "lessons", data: Log.lessons.group_by_day(:created_at, last: 8).count
	    }, {
	      name: "sum", data: Log.group_by_day(:created_at, last: 8).count
	    }
		]
		@characters_chart = Character.group_by_day(:created_at, last: 12).count
	end
end
