class DomainsController < ApplicationController
	respond_to :html, :xml, :json
	before_action :get_idea, :get_user
	require 'robowhois'

	def index
		unless params[:search].blank?

			#Establish a call to the API to search
			client = RoboWhois.new(:api_key => '5c058dc8594cce541b386c16412279f3')

			domainsearch = client.whois_properties(params[:search])

			@domainresults = Domain.new
			@domainresults.name = domainsearch['properties']['domain']
			@domainresults.url = domainsearch['properties']['domain']
			@domainresults.domainstatus_id = domainsearch['properties']['status'].blank? ? "available" : domainsearch['properties']['status']
			@domainresults.expirationdate = domainsearch['properties']['expires_on']
		end
	end

	def create
		@domain = @idea.domains.build(domain_params)
		@domain.name = params[:name]
		@domain.url = params[:url]
		@domain.domainstatus_id = params[:domainstatus_id]
		@domain.expirationdate = params[:expirationdate]

		#Search existing domains to see if the domain exists
		@domainsearch = Domain.search(@domain.url)
		
		if @domainsearch.count === 0
			#Add the domain to the database
			if @domain.save
				#After the domain has been added to the database successfully, add the association for the given idea
				@ideadomain = Ideadomain.create(:idea_id => @idea.id, :domain_id => @domain.id, :user_id => @user.id)
			else
				redirect_to idea_domain_path(@idea), :notice => "The domain was unable to be added to your watchlist"
			end
		else
			#If the domain already exists, just create the association to add to the watchlist
			@ideadomain = Ideadomain.create(:idea_id => @idea.id, :domain_id => domainsearch.id, :user_id => @user.id)
			redirect_to idea_domain_path(@idea), :notice => "The domain was unable to be added to your watchlist"
		end
	end

	private

	def domain_params
		params.fetch(:domain, {}).permit(:name, :url, :domainstatus_id, :expirationdate)
	end

	def get_idea
		@idea = Idea.find(params[:idea_id])
	end

	def get_user
		@user = current_user
	end
end
