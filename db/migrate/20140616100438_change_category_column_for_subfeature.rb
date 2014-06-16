class ChangeCategoryColumnForSubfeature < ActiveRecord::Migration
  def self.up
  	rename_column :subfeatures, :category, :subfeaturecategory_id
  end
end
