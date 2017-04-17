class CharactersController < ApplicationController
	add_breadcrumb 'Characters', 'characters_path'
	  
	def index
	  @q = Character.includes(:logs).order(:created_at).search(params[:q])
	  @characters = @q.result.paginate(:page => params[:page])
	end
	
	def show
		@character = Character.find(params[:id])
		add_breadcrumb @character.character, "character_path(@character.id)"
	end

end
