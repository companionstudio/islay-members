class Subscription < ActiveRecord::Base
  belongs_to :series
  belongs_to :member

  def self.active
    where(:active => true)
  end

  def self.latest
    active.order('created_at DESC').limit(1).first
  end

  alias_method :subscriber, :member

  def deactivate!
    self.update_attribute(:active, false)
  end

  def activate!
    self.update_attribute(:active, true)
  end
end
