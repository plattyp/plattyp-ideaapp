ActiveAdmin.register Setting do

permit_params :id, :settingtype, :value, :admin_default

index do
  column :id
  column :settingtype
  column :value
  column :admin_default
  default_actions
end

filter :admin_default
filter :settingtype
  
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end
  
end
