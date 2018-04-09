class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer   :member_id,     :null => false
      t.integer   :series_id,     :null => false
      t.boolean   :active,        :default => true
      t.timestamps
    end
  end
end
