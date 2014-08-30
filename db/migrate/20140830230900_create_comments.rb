class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :hc_id, :null => false
      t.text :url, :null => false
      t.integer :acc_id

      t.text :additional_info, :default => {}.to_yaml

      t.timestamps
    end

    add_index :comments, :hc_id, :unique => true
    add_index :comments, :created_at
    add_index :comments, :url
    add_index :comments, :acc_id
  end
end
