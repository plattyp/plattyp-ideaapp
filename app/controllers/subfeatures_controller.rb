class SubfeaturesController < ApplicationController
  respond_to :html, :xml, :json
  before_action :get_idea, :get_user, :get_feature, :check_user_access

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


    #This is to support the rest of the functionality on the pag
    @subfeaturestatuses = Subfeature.subfeaturestatuslist

    #Gets a list of subfeatures' categories for a given feature
    @uniquecategories = Subfeaturecategory.returnideacategories(@idea.id)

    #Creates a hash 
    @subfeaturesdistinct = Hash.new

    #Iterates through the list of subfeature categories and hashes the name and the count of subfeatures within each category
    @uniquecategories.each do |category|
      #Calls the model method to get a count of subfeatures in that category
      subfeaturecount = Subfeature.subfeature_count(params[:feature_id],category.id)
      @subfeaturesdistinct.store(category.id,subfeaturecount)
    end
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

  def check_user_access
    unless @user.ideas.find_by_id(params[:idea_id])
      redirect_to ideas_path, :notice => "You do not have access to edit this idea!"
    end
  end
end
