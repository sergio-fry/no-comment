class AddTextAndStatusToPages < ActiveRecord::Migration
  def change
    add_column :pages, :text, :text
    add_column :pages, :status, :integer, :default => Page::STATUS_NEW, :null => false

    add_index :pages, :status
  end
end
