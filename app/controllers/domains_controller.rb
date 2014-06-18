class DomainsController < ApplicationController
	respond_to :html, :xml, :json
	before_action :get_idea, :get_user
	require 'robowhois'

	def index
		unless params[:domain].blank?

			#Parses out the search field to be used in the search below
			params[:domain].each do |d,v|
				@search = v
			end

			#Creates an object to return the results
			@domainresults = Domain.new

			#Initially searches the domain within our database to see if it has been searched prior
			@domainsearch = Domain.search(@search)

			#If the search brings back no results, use the API to get the information otherwise return the info from our database
			if @domainsearch.count === 0	
				#Establish a call to the API to search
				client = RoboWhois.new(:api_key => '5c058dc8594cce541b386c16412279f3')

				#Pass the search URL
				domainsearch = client.whois_properties(@search)

				#Set the object with the properties from the API Search
				@domainresults.name = @search
				@domainresults.url = @search
				@domainresults.domainstatus_id = domainsearch['properties']['available?'] ? "available" : "registered"
				@domainresults.expirationdate = domainsearch['properties']['expires_on']

				#Store the results in our database so that they can be used in the future
				Domain.create(:name => @domainresults.name, :url => @domainresults.url, :domainstatus_id => @domainresults.domainstatus_id, :expirationdate => @domainresults.expirationdate)
			else
				#Load the results from our database into the object
				@domainsearch.each do |d|
					@domainresults.name = d.name
					@domainresults.url = d.url
					@domainresults.domainstatus_id = d.domainstatus_id
					@domainresults.expirationdate = d.expirationdate
				end
			end
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
				ideadomain = Ideadomain.create(:idea_id => @idea.id, :domain_id => @domain.id, :user_id => @user.id)
			else
				redirect_to idea_domain_path(@idea), :notice => "The domain was unable to be added to your watchlist"
			end
		else
			#If the domain already exists, just create the association to add to the watchlist
			@domainsearch.each do |d|
				ideadomainsearch = Ideadomain.search(@idea.id,d.id)
				if ideadomainsearch.count === 0
					ideadomain = Ideadomain.create(:idea_id => @idea.id, :domain_id => d.id, :user_id => @user.id)
					redirect_to idea_domains_path(@idea.id), :notice => "The domain has been added to your watchlist"
				else
					redirect_to idea_domains_path(@idea.id), :notice => "The domain is already being watched"
				end
			end
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