module InvitedusersHelper
	#Used by the InvitedUsers controller to return a joint list of Invited and Idea Users
	def self.return_alluserslist(idea_id)
		#First create the Hash the will store both users joined and not joined
		@users = Array.new

		#Returns a list of usernames & roles for users currently added
		@ideausers = User.return_ideausers(idea_id)

		#Creates an array of emails of users that are already on the site
		emails = Array.new

		#Iterate through the users that are currently part of the idea and add their emails to the array
		@ideausers.each do |e|
			emails << e.email
		end

		#Returns a list of emails and roles not currently within the Idea
		@invitedusers = Inviteduser.return_invitedusers(idea_id, emails)

		#Stores all users that belong to the site into the Hash
		@ideausers.each do |i|
			@users << [i.username,"Joined",i.role,i.id,i.imageurl]
		end

		#Stores all users that are invited but not yet on the site
		@invitedusers.each do |x|
			@users << [x.emailaddress,"Hasn't Joined",x.role,x.id,nil]
		end

		return @users
	end
end
