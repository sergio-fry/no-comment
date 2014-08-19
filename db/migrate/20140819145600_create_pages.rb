class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.text :url, :null => false
      t.text :title
      t.text :description
      t.string :domain, :null => false
      t.text :img
      t.integer :comments_count, :default => 0

      t.text :additional_info, :default => {}.to_yaml

      t.timestamps
    end

    add_index :pages, :created_at
    add_index :pages, :updated_at
    add_index :pages, :url
    add_index :pages, :domain
    add_index :pages, :comments_count
  end
end
