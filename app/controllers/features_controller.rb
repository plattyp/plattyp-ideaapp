class FeaturesController < ApplicationController
	respond_to :html, :xml, :json
	before_action :get_idea

	def index
		@features = @idea.features.all
	end

	def show
		@feature = @idea.features.find(params[:id])
	end

	def new
		@feature = @idea.features.build
		respond_with(@feature)
	end

	def create
		@feature = @idea.features.build(feature_params)
		if @feature.save
			redirect_to edit_idea_path(@idea, :anchor => 'features'), :notice => "The feature was added!"
		else
			redirect_to new_idea_features_path(@idea), :notice => "Sorry, but the feature could not be added!"
		end
	end

	def edit
		@feature = @idea.features.find(params[:id])
	end

	def update
		@feature = @idea.features.find(params[:id])

	  	if @feature.update_attributes(feature_params)
	  		redirect_to edit_idea_path(@idea), :notice =>"The feature is updated!"
	  	else
	      	redirect_to new_idea_features_path(@idea), :notice => "Sorry, but the feature could not be added!"
	  	end
	end

	def destroy
		@feature = @idea.features.find(params[:id])
		@feature.destroy
		redirect_to edit_idea_path(@idea), :notice =>"The feature was deleted!"
	end

	private

	def feature_params
		params.require(:feature).permit(:name, :description, :idea_id)
	end

	def get_idea
		@idea = Idea.find(params[:idea_id])
	end

end
