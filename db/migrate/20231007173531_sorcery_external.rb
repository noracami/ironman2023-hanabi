class SorceryExternal < ActiveRecord::Migration[7.0]
  def change
    create_table :authentications do |t|
      t.integer :player_id, null: false
      t.string :provider, :uid, null: false

      t.timestamps              null: false
    end

    add_index :authentications, [:provider, :uid]
  end
end
