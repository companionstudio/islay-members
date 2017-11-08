class CreateMemberAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.integer   :member_id,     :null => false
      t.boolean   :default,       :default => false
      t.string    :status,        :limit => 64, :default => 'active', :null => false
      t.string    :type,          :limit => 64, :default => 'billing', :null => false

      t.string    :company,       :limit => 200,  :null => false
      t.string    :street,        :limit => 200,  :null => false
      t.string    :city,          :limit => 200,  :null => false
      t.string    :state,         :limit => 200,  :null => false
      t.string    :postcode,      :limit => 25,   :null => false
      t.string    :country,       :limit => 2,    :null => false # ISO 3166 alpha-2

      t.string    :instructions,  :limit => 4000

      t.timestamps
    end

  end
end
