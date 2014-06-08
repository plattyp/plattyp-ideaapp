module SubfeaturesHelper

def span_classname(status)
  case status
  when "Proposed"
  	classname = "info"
  when "Considering"
  	classname = "warning"
  when "Validated"
  	classname = "primary"
  when "Approved"
  	classname = "success"
  when "Obsolete"
  	classname = "danger"
  end

   "label label-#{classname}" unless classname.nil?
end

end
