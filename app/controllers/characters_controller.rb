class CharactersController < ApplicationController
	add_breadcrumb 'Characters', 'characters_path'
	  
	def index
	   @characters = Character.paginate(:page => params[:page])
	end
	def show
		@character = Character.find(params[:id])
		add_breadcrumb @character.character, "character_path(#{@character.id})"
	end

	def new
	end

	def create
	end
end
