class SubfeaturecategoriesController < ApplicationController
  respond_to :html, :xml, :json
  before_action :get_idea, :get_user

  def index
    @subfeaturecategories = @idea.subfeaturecategories.all
  end

  def edit
    @subfeaturecategory = @idea.subfeaturecategories.find(params[:id])
  end

  def update
    @subfeaturecategory = Subfeaturecategory.find(params[:id])

    respond_to do |format|
      if @subfeaturecategory.update(subfeaturecategory_params)
        format.html { redirect_to idea_subfeaturecategories_path(@idea), notice: 'Subcategory was successfully updated' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @subfeaturecategory.errors, status: :unprocessable_entity}
      end
    end

    # @subfeaturecategory = @idea.subfeaturecategories.find(params[:id])

    # if @subfeaturecategory.update_attributes(subfeaturecategory_params)
    #   redirect_to edit_idea_feature_path(@idea, @feature), :notice => "The subfeature category was updated"
    # else
    #   redirect_to edit_idea_feature_path(@idea, @feature), :notice => "The subfeature category was not updated"
    # end
  end

  def new
    @subfeaturecategory = @idea.subfeaturecategories.build
  end

  def create
    @subfeaturecategory = @idea.subfeaturecategories.build(subfeaturecategory_params)
    @subfeaturecategory.idea_id = @idea.id

    if @subfeaturecategory.save
      redirect_to idea_subfeaturecategories_path(@idea), :notice => "The subfeature category was added!"
    else
      redirect_to idea_subfeaturecategories_path(@idea), :notice => "Sorry, but the subfeature category could not be added!"
    end
  end

  def destroy
    @subfeaturecategory = @idea.subfeaturecategories.find(params[:id])
    @subfeaturecategory.destroy
    redirect_to idea_subfeaturecategories_path(@idea), :notice => "The subfeature category was deleted!"
  end

  private

  def subfeaturecategory_params
    params.require(:subfeaturecategory).permit(:categoryname)
  end

  def get_idea
    @idea = Idea.find(params[:idea_id])
  end

  def get_user
    @user = current_user
  end
end
