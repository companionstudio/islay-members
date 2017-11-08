class PaymentMethods < ActiveRecord::Migration
  def change
    create_table :PaymentMethods do |t|
      t.integer   :member_id,     :null => false
      t.boolean   :default,       :default => false
      t.string    :label,         :limit => 64, :default => 'Main card', :null => false
      t.string    :status,        :limit => 64, :default => 'active', :null => false
      t.string    :type,          :limit => 64, :default => 'credit_card', :null => false
      t.string    :issuer,        :limit => 64
      t.string    :provider,      :limit => 64
      t.string    :vault_token,   :limit => 512
      t.date      :vault_expiry

      t.timestamps
    end
  end
end
