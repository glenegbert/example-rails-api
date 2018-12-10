class CreateZones < ActiveRecord::Migration[5.2]
  def change
    create_table :zones do |t|
      t.string :title, null: false, unique: true
      t.integer :impressions, null: false

      t.timestamps
    end
  end
end
