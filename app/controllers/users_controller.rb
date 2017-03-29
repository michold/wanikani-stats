class UsersController < ApplicationController

	def update
		User.update_attributes
		respond_to do |format|
		  format.json { render :json => {
		  	:status => :ok, 
		  }}
		end
	end
end
