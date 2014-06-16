class IdeadomainsController < ApplicationController
	respond_to :html, :xml, :json
	before_action :get_idea
	
	def create
		@ideadomain = @idea.ideadomain.build(ideadomain_params)
		if @ideadomain.save
			redirect_to idea_domain_path(@idea), :notice => "The domain was added to your watchlist!"
		else
			redirect_to idea_domain_path(@idea), :notice => "The domain was unable to be added to your watchlist"
		end
	end

	def destroy
		@ideadomain = @idea.ideadomains.find(params[:id])
		@ideadomain.destroy
		redirect_to idea_domains_path(@idea), :notice => "The domain was removed from your watchlist!"
	end

	private

	def ideadomain_params
		params.require(:ideadomain).permit(:domain_id, :idea_id, :user_id)
	end

	def get_idea
		@idea = Idea.find(params[:idea_id])
	end
end
