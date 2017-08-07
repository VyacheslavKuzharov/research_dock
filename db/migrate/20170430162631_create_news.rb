class CreateNews < ActiveRecord::Migration[5.0]
  def change
    create_table :news do |t|
      t.string   :title
      t.datetime :date
      t.text     :description
      t.string   :url
      t.integer  :site_id
      t.integer  :city_id
      t.integer  :region_id
      t.boolean  :main_news, default: false
      t.string   :image

      t.timestamps
    end
  end
end
