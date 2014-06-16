class SubfeaturecategoriesController < ApplicationController
  def index
  end

  def edit
  end

  def update
  end

  def new
    @subfeaturecategory = @idea.subfeaturecategories.build
  end

  def create
    @subfeaturecategory = @idea.subfeaturecategories.build(subfeaturecategory_params)

    if @subfeaturecategory.save
      redirect_to edit_idea_feature_path(@idea, @feature), :notice => "The subfeature category was added!"
    else
      redirect_to new_idea_feature_subfeature_path(@idea, @feature), :notice => "Sorry, but the subfeature category could not be added!"
    end
  end

  def destroy
  end

  private

  def subfeaturecategory_params
    params.require(:subfeaturecategory).permit(:categoryname, :idea_id)
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
