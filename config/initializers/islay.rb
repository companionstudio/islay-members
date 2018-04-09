Islay::Engine.extensions.register do |e|
  e.namespace :islay_members

  e.admin_styles true
  e.admin_scripts true

  e.configuration('Members', :islay_members) do |c|
    c.string  :notification_email
  end

  e.reports('Members', :member_reports, :class => 'user')

  e.dashboard(:primary, :top, :memberships)

  e.nav_section(:club) do |s|
    s.root('Club', :club_dashboard, 'user')
    s.sub_nav('Dashboard',        :club_dashboard, root: true)
    s.sub_nav('Series & Offers',  :series_index)
    s.sub_nav('Members',          :members)
  end

  e.nav_section(:reports) do |s|
    s.sub_nav('Members', :member_reports)
  end

  # Hook into the shop if present
  if defined?(::IslayShop)
    Order.class_eval do
      has_one :member_order
      has_one :member, through: :member_order

      has_one :offer_order
      has_one :offer, through: :offer_order
    end
  
  end

end
