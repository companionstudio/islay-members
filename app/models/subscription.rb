class Subscription < ActiveRecord::Base
  belongs_to :series
  belongs_to :subscriber, class_name: 'Member'

  def self.active
    where(:active => true)
  end

  def self.latest
    active.order('created_at DESC').limit(1).first
  end
end
