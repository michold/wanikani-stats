class ReportsController < ApplicationController
	add_breadcrumb 'Reports', 'reports_path'
	before_filter :get_filters, :except => [:index]

	def index
		@reports = [
			{
				:name => 'Reviews and lessons completed',
				:action => :logs_by_time,
			},
			{
				:name => 'Characters learned',
				:action => :characters_by_time,
			}
		]
	end
	def logs_by_time
		add_breadcrumb 'Reviews and lessons completed', "reports_logs_by_time_path"
		filtered_logs = filter(Log).group_by_day(:created_at, @time_options)
		@chart = [
		    {
		      name: "reviews", data: filtered_logs.reviews.count
		    }, {
		      name: "lessons", data: filtered_logs.lessons.count
		    }, {
		      name: "sum", data: filtered_logs.count
		    }
		]
	end
	def characters_by_time
		add_breadcrumb 'Characters learned', "reports_characters_by_time_path"
		filtered_characters = filter(Character)
		@chart = filtered_characters.group_by_day(:created_at, @time_options).count
	end

	def get_filters
		@filters = []
		@time_options = {}
		if params.has_key?(:daterange)
			@daterange = params[:daterange]
			range = params[:daterange].split(" - ")
			date_format = "%d.%m.%Y"
			start_date = Date.strptime(range[0], date_format)
			end_date = Date.strptime(range[1], date_format)
			@time_options[:range] = start_date..end_date 

		else
			@daterange = nil
			@time_options[:range] = 7.days.ago..Time.now
		end
		@filters
	end

	def filter (records)
		@filters.each do |key, val|
			# case key
				records = records.where(key, val)
			# end
		end
		records
	end
end
