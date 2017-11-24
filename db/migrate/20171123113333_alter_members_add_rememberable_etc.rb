class AlterMembersAddRememberableEtc < ActiveRecord::Migration
  def change
    add_column :members, :remember_created_at, :datetime
  end
end
