class SubfeaturesController < ApplicationController
  respond_to :html, :xml, :json
  before_action :get_idea, :get_user, :get_feature

  def index
    @subfeatures = @feature.subfeatures.all
  end

  def new
    @subfeature = @feature.subfeatures.build
    #Gets a list of subfeatures' categories
    @uniquecategories = Subfeaturecategory.returnideacategories(@idea.id)
  end

  def create
    @subfeature = @feature.subfeatures.build(subfeature_params)
    @subfeature.user_id = @user.id
    @subfeature.idea_id = @idea.id
    @subfeature.feature_id = @feature.id

    if @subfeature.save
      redirect_to edit_idea_feature_path(@idea, @feature), :notice => "The subfeature was added!"
    else
      redirect_to new_idea_feature_subfeature_path(@idea, @feature), :notice => "Sorry, but the subfeature could not be added!"
    end

  end

  def edit
    @subfeature = @feature.subfeatures.find(params[:id])
  end

  def update
    @subfeature = @feature.subfeatures.find(params[:id])

    @subfeature.status = params[:status]

    if @subfeature.update_attributes(subfeature_params)
      redirect_to edit_idea_feature_path(@idea, @feature), :notice => "The subfeature was updated"
    else
      redirect_to edit_idea_feature_path(@idea, @feature), :notice => "Sorry, but the subfeature could not be updated."
    end
  end

  def destroy
    @subfeature = @feature.subfeatures.find(params[:id])
    @subfeature.destroy
    redirect_to edit_idea_feature_path(@idea, @feature), :notice =>"The subfeature was deleted!"
  end

  private

  def subfeature_params
    params.fetch(:subfeature, {}).permit(:name, :description, :subfeaturecategory_id, :status) 
  end

  def get_idea
    @idea = Idea.find(params[:idea_id])
  end

  def get_user
    @user = current_user
  end

  def get_feature
    @feature = Feature.find(params[:feature_id])
  end
end
