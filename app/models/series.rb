class Series < ActiveRecord::Base
  has_many :subscriptions
  has_many :subscribers, through: :subscriptions, class_name: 'Member'

  def self.filtered(filter)
    case filter
    when 'all' then all
    when 'disabled' then where.not(:active => true)
    else where(:active => true)
    end
  end

end
