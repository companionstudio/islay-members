class CreateSeries < ActiveRecord::Migration
  def change
    create_table :series do |t|
      t.boolean   :active,        :default => true

      t.string    :name,          :limit => 128,  :null => false
      t.string    :description,   :limit => 2000, :null => false
      t.string    :frequency,     :limit => 128,  :null => false
      t.float     :base_price,    :null => false, :precision => 7,  :scale => 2

      t.timestamps
    end
  end
end
