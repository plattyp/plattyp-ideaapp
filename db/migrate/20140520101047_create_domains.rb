class CreateDomains < ActiveRecord::Migration
  def change
    create_table :domains do |t|
      t.string :name
      t.date :expirationdate
      t.string :url
      t.string :domainstatus_id

      t.timestamps
    end
  end
end
