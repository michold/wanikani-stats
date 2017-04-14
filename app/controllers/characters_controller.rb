class CharactersController < ApplicationController
	add_breadcrumb 'Characters', 'characters_path'
	  
	def index
	   @characters = Character.paginate(:page => params[:page]).includes(:logs)
	   if params.has_key?(:character_types)
	   	@selected_character_types = params[:character_types]
	   	@characters = @characters.where(type: @selected_character_types)
	   end

	end
	
	def show
		@character = Character.find(params[:id])
		add_breadcrumb @character.character, "character_path(@character.id)"
	end

end
