class CreateUser < ActiveRecord::Migration
  def up
    create_table "identities" do |t|
      t.string "name"
      t.string "email", :null => false
      t.string "password_digest", :null => false
    end
  end

  def down
    delete_table "identities"
  end
end
