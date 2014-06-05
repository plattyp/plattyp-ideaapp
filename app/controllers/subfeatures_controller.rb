class SubfeaturesController < ApplicationController
  respond_to :html, :xml, :json
  before_action :get_idea, :get_user, :get_feature

  def index
    @subfeatures = @feature.subfeatures.all
  end

  def new
    @subfeature = @feature.subfeatures.build
  end

  def create
    @subfeature = @feature.subfeatures.build(subfeature_params)
    @subfeature.user_id = @user.id
    @subfeature.idea_id = @idea.id
    @subfeature.feature_id = @feature.id
    @subfeature.status = "New"

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

    if @subfeature.update_attributes(subfeature_params)
      redirect_to edit_idea_feature_subfeature_path(@idea, @feature, @subfeature), :notice =>"The subfeature is updated!"
    else
      redirect_to edit_idea_feature_subfeature_path(@idea, @feature, @subfeature), :notice => "Sorry, but the subfeature could not be updated!"
    end
  end

  def destroy
  end

  private

  def subfeature_params
    params.require(:subfeature).permit(:name, :description, :category, :status)
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
