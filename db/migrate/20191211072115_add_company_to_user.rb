class AddCompanyToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :company, :boolean, default: false
  end
end
