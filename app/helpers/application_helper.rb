module ApplicationHelper
	def self.profilepicture(imageurl,size)
		if imageurl.blank?
			#Default picture if none is provided
			"profilepicbin1_mini.png"
		else
			#Replaces the end part of the URL so that the picture is only 30px
			imageurl[0,imageurl.length - 2] + size.to_s
		end
	end

	def title(title = nil)
		if title.present?
			content_for :title, title
		else
			content_for?(:title) ? Setting.retrieve_metatags("metatitle").value + ' | ' + content_for(:title) : Setting.retrieve_metatags("metatitle").value
		end
	end
end
