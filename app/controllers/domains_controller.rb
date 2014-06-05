class DomainsController < ApplicationController
	respond_to :html, :xml, :json
	before_action :get_idea, :get_user

	def index
		if params[:search]
			@domains = Domain.search(params[:search])
		else
			@domains = Domain.all
		end
	end

	def new
		@domain = Domain.new
	end

	def create
		@domain = @idea.domains.build(domain_params)
		@domain.ideadomains.build(:user_id => @user.id, :idea => @idea)
		#Search existing domains to see if the domain exists
		@domainsearch = Domain.search(@domain.url)

		if @domainsearch.blank?
			render :action => "new", :notice => "No results found"
		else
			render :action => "new", :notice => "We found a result!"
		end
	end

	private

	def domain_params
		params.require(:domain).permit(:url, ideadomain_attributes: [:idea_id, :user_id])
	end

	def get_idea
		@idea = Idea.find(params[:idea_id])
	end

	def get_user
		@user = current_user
	end
end
