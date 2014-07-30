module RegistrationsHelper
	def self.providertext(provider)
		case provider.to_s
		when "google_oauth2"
			providername = "Google"
		end
			"Sign in with #{providername}"
	end
end
