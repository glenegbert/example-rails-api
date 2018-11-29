class CreateZones < ActiveRecord::Migration[5.2]
  def change
    create_table :zones do |t|
      t.string :title
      t.integer :impressions

      t.timestamps
    end
  end
end
