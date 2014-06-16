module IdeadomainsHelper
	#Passing in the idea_id and domain_id will retrieve the unique ID for the ideadomain to be sent to remove him.
	def self.return_associatedid(idea_id, domain_id)
		Ideadomain.search(idea_id, domain_id)
	end

	def self.span_classname(domainstatus_id)
	  case domainstatus_id
	  when "registered"
	  	classname = "warning"
	  when "available"
	  	classname = "primary"
	  end

	  "label label-#{classname}" unless classname.nil?
	end
end
