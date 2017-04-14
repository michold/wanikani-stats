class ReportsController < ApplicationController
	add_breadcrumb 'Reports', 'reports_path'
	before_action :get_filters, :except => [:index]

	def index
		@reports = [
			{
				:name => 'Reviews and lessons completed',
				:action => :logs_by_time,
			},
			{
				:name => 'Characters learned',
				:action => :characters_by_time,
			},
			# {
			# 	:name => 'Character level changes',
			# 	:action => :character_level_changes,
			# },
			{
				:name => 'Correct answers percentage',
				:action => :correct_answers_percentage,
			},
		]
	end

	def logs_by_time
		add_breadcrumb 'Reviews and lessons completed', "reports_logs_by_time_path"
		filtered_logs = filter(Log.includes(:character)).group_by_day("logs.created_at", @time_options)
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

	def character_level_changes
		add_breadcrumb 'Character level changes', "reports_character_level_changes_path"
		# @chart = [
		# 	{
		# 		name: "a => l", data: {"March 26, Sunday"=>90, "March 27, Monday"=>50, "March 28, Tuesday"=>50, "March 29, Wednesday"=>50, "March 30, Thursday"=>50, "March 31, Friday"=>50, "April  1, Saturday"=>50, "April  2, Sunday"=>50}
		# 	}, {
		# 		name: "a => g", data: {"March 26, Sunday"=>10, "March 27, Monday"=>50, "March 28, Tuesday"=>50, "March 29, Wednesday"=>50, "March 30, Thursday"=>50, "March 31, Friday"=>50, "April  1, Saturday"=>50, "April  2, Sunday"=>50}
		# 	}

		# ]
	end

	def correct_answers_percentage
		add_breadcrumb 'Correct answers percentage', "reports_correct_answers_percentage_path"
		filtered_logs = filter(Log.joins(:character)).all.group_by_day(@time_options, &:created_at)

		@chart = {}
		filtered_logs.each do |day, logs|
			@chart[day] = Log.get_correct_percentage(logs)
		end
	end

	private

	def get_filters
		@filters = {}
		@time_options = {
			format: Rails.application.config.date_format_long
		}
		if params.has_key?(:daterange)
			@daterange = params[:daterange]
			range = params[:daterange].split(" - ")
			date_format = Rails.application.config.date_format_short
			start_date = Date.strptime(range[0], date_format)
			end_date = Date.strptime(range[1], date_format)
			@time_options[:range] = start_date..end_date 

		else
			@time_options[:range] = 7.days.ago.beginning_of_day..Time.now
		end

		if params.has_key?(:character_types)
			@selected_character_types = params[:character_types]
			@filters[:character_types] = @selected_character_types
		end
		@filters
	end

	def filter (records)
		@filters.each do |key, val|
			case key
				when :character_types
					if records.name == 'Log'
						records = records.where(:characters => {:type => val})
					elsif records.name == 'Character'
						records = records.where(:type => val)
					end
			end
		end
		records
	end
end
