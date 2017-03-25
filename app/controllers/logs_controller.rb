class LogsController < ApplicationController
	# def index
	#    @logs = Log.paginate(:page => params[:page]).order('created_at DESC')
	# end

	# def show
	# 	@log = Log.find(params[:id])
	# end

	def generate
		Log.load_new_logs
		respond_to do |format|
		  format.json { render :json => {
		  	:status => :ok, 
		  }}
		end
	end

	# def create
	# 	@log = Log.new(log_params)
		
	# 	@log.save
	# 	redirect_to @log
	# end

	# private

	# def log_params
	# 	# params.require(:log).permit(:date, :level, :amount)
	# end
end
