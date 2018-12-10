class CreateAds < ActiveRecord::Migration[5.2]
  def change
    create_table :ads do |t|
      t.string :creative, null: false
      t.integer :priority, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.integer :goal, null: false
      t.references :zone, foreign_key: true

      t.timestamps
    end
  end
end
