class AddColumnsToMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :name, :string
    add_column :messages, :apiKey, :string
    add_column :messages, :sessionID, :string
    add_column :messages, :token, :string
  end
end
