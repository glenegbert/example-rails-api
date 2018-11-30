class AddIndexToAds < ActiveRecord::Migration[5.2]
  def change
    remove_index(:ads, name: "index_ads_on_zone_id")
    add_index(:ads, :zone_id, order: { priority: :desc }, name: "index_ads_on_zone_id_orderd")
  end
end
