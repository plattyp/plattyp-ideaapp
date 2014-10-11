class Setting < ActiveRecord::Base
	self.table_name = "settings"
	belongs_to :group

	def self.retrieve_adminvalues(settingtype)
		if settingtype.blank?
			Setting.where("admin_default = true")
		else
			Setting.where("admin_default = true AND settingtype = ?", settingtype)
		end
	end

	def self.retrieve_groupvalues(group_id,settingtype)
		Setting.where("group_id = ? AND settingtype = ?", group_id, settingtype)
	end

	def self.retrieve_metatags(metatype)
		unless metatype.blank?
			Setting.where("admin_default = true AND settingtype = ?",metatype).select("value").first
		end
	end
end
