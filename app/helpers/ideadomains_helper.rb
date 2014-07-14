module IdeadomainsHelper
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
