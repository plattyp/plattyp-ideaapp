class FeaturesController < ApplicationController
	respond_to :html, :xml, :json
	before_action :get_idea, :get_user

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
		@feature.user_id = @user.id
		if @feature.save
			redirect_to edit_idea_feature_path(@idea, @feature), :notice => "The feature was added!"
		else
			redirect_to new_idea_features_path(@idea), :notice => "Sorry, but the feature could not be added!"
		end
	end

	def edit
		@feature = @idea.features.find(params[:id])
		@uniquecategories = Subfeature.unique_categories(params[:id])

		@subfeaturesdistinct = Hash.new
		@uniquecategories.each do |category|
			subfeaturecount = Subfeature.subfeature_count(params[:id],category)
			@subfeaturesdistinct.store(category,subfeaturecount)
		end
	end

	def update
		@feature = @idea.features.find(params[:id])

	  	if @feature.update_attributes(feature_params)
	  		redirect_to edit_idea_path(@idea), :notice =>"The feature is updated!"
	  	else
	      	redirect_to edit_idea_path(@idea), :notice => "Sorry, but the feature could not be updated!"
	  	end
	end

	def destroy
		@feature = @idea.features.find(params[:id])
		@feature.destroy
		redirect_to idea_features_path(@idea), :notice =>"The feature was deleted!"
	end

	private

	def feature_params
		params.require(:feature).permit(:name, :description, :idea_id)
	end

	def get_idea
		@idea = Idea.find(params[:idea_id])
	end

	def get_user
		@user = current_user
	end

end
