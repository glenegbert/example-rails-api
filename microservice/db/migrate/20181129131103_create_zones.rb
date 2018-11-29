class CreateZones < ActiveRecord::Migration[5.2]
  def change
    create_table :zones do |t|
      t.string :title, null: false
      t.integer :impressions, null: false

      t.timestamps
    end
  end
end
