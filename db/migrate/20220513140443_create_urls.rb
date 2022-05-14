class CreateUrls < ActiveRecord::Migration[6.1]
  def change
    create_table :urls do |t|
      t.string :original_url, index: true
      t.string :shorten_url, index: true
      t.integer :often_shorten, default: 1, index: true
      t.integer :often_access, default: 0, index: true
      t.boolean :is_public, default: true, index: true
      t.boolean :status, default: true, index: true
      t.integer :user_id, index: true
      t.datetime :last_access_at, index: true

      t.timestamps
    end
  end
end
