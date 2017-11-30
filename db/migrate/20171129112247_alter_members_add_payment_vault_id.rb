class AlterMembersAddPaymentVaultId < ActiveRecord::Migration
  def change
    add_column :members, :payment_vault_id, :string, :limit => 256
  end
end
