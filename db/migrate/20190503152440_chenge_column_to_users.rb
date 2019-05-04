class ChengeColumnToUsers < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :activation_digest, :string
  end
end
