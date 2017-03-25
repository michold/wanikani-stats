class LogsController < ApplicationController
	# def index
	#    @logs = Log.paginate(:page => params[:page]).order('created_at DESC')
	# end
	# def show
	# 	@log = Log.find(params[:id])
	# end

	def generate
		# Log.load_new_logs
		respond_to do |format|
		  format.json { render :json => {
		  	:status => :ok, 
		 #  	:data => {
		 #  	  "def" => 'aaa'
			# }
		  }}
		end
	end

	# def create
	# 	@log = Log.new(level_count_params)
		
	# 	@article.save
	# 	redirect_to @article
	# end

	# private

	# def level_count_params
	# 	# params.require(:log).permit(:date, :level, :amount)
	# end
end
