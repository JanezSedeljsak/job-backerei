class AddUserToCandidates < ActiveRecord::Migration[5.1]
  def change
    add_reference :candidates, :user, foreign_key: true
  end
end
