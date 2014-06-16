class SubfeaturecategoryIdToIntegerForSubfeatures < ActiveRecord::Migration
  def change
  	change_column :subfeatures, :subfeaturecategory_id, 'integer USING CAST(subfeaturecategory_id AS integer)'
  end
end
