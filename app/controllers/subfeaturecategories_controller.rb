class SubfeaturecategoriesController < IdeasController
  respond_to :html, :xml, :json
  before_action :get_idea, :get_user, :get_group, :check_user_access

  def index
    @subfeaturecategories = Subfeaturecategory.returnideacategories(@idea.id)

    @subfeaturecategorieswithcount = []

    @subfeaturecategories.each do |i|
      subfeaturecategory = [i.id, i.categoryname, Subfeaturecategory.idea_subfeature_count(@idea.id,i.id)]
      @subfeaturecategorieswithcount << subfeaturecategory
    end

    #Create an instance variable to create new subfeature categories from the index
    @subfeaturecategory = @idea.subfeaturecategories.build

    #Return unread messages count
    @unread_message_count = notification_count("Ideamessage")
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

  def check_user_access
    unless @user.ideas.find_by_id(params[:idea_id])
      redirect_to ideas_path, :notice => "You do not have access to edit this idea!"
    end
  end
end
