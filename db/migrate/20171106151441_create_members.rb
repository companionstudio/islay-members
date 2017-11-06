class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string    :name,                    :null => false, :limit => 200
      t.string    :email,                   :null => false, :limit => 200, :index => :unique
      t.string    :encrypted_password,      :null => false, :limit => 200
      t.string    :reset_password_token,    :null => true,  :limit => 200, :index => :unique
      t.datetime  :reset_password_sent_at,  :null => true
      t.string    :status,                  :null => false, :limit => 64, :default => 'inactive'

      t.timestamps
    end
  end
end
