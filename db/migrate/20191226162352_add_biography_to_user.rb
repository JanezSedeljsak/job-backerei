class AddBiographyToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :biography, :string
  end
end
