class CreateMemberOrders < ActiveRecord::Migration
  def change
    create_table :member_orders do |t|
      t.integer   :member_id,    :null => false
      t.integer   :order_id,     :null => false
    end
  end
end
