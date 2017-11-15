class MemberOrder < ActiveRecord::Base
  belongs_to :member
  belongs_to :order
end
