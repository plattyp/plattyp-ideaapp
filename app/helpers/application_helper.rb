module ApplicationHelper
	def self.profilepicture(imageurl)
		if imageurl.blank?
			#Default picture if none is provided
			"profilepicbin1_mini.png"
		else
			#Replaces the end part of the URL so that the picture is only 30px
			imageurl[0,imageurl.length - 2] + "30"
		end
	end
end
