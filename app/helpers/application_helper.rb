module ApplicationHelper
	def self.profilepicture(imageurl)
		if imageurl.blank?
			"profilepicbin1_mini.png"
		else
			imageurl[0,imageurl.length - 2] + "30"
		end
	end
end
