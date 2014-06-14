class DomainsController < ApplicationController
	respond_to :html, :xml, :json
	before_action :get_idea, :get_user
	require 'whois'

	def index
		unless params[:search].blank?
			@domainsearch = Whois.whois(params[:search])

			@domainsearch.each do |s|
				@domainresults.url = s.domain
				@domainresults.status = s.status
				@domainresults.expirationdate = s.expires_on
			end
		end
	end

	def new
		@domain = Domain.new
	end

	def create
		@domain = @idea.domains.build(domain_params)

		#Setting attribute values now until this actually looks up the info from Whois
		@domain.name = params[:url]
		@domain.url = params[:url]
		@domain.domainstatus_id = "Added"
		@domain.expirationdate = Time.zone.now.to_date

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
		end
	end

	private

	def domain_params
		params.fetch(:domain, {}).permit(:url)
	end

	def get_idea
		@idea = Idea.find(params[:idea_id])
	end

	def get_user
		@user = current_user
	end
end
