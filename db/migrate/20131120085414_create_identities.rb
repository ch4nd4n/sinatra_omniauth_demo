class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.string :user_id
      t.string :provider
      t.string :uid
      t.references :user
    end
  end
end