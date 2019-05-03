class ChangeDatatypeNameOfUsers < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :name, :string
  end
end
