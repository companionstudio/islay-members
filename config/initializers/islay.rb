Islay::Engine.extensions.register do |e|
  e.namespace :islay_members

  e.admin_styles true
  e.admin_scripts true

  e.configuration('Members', :islay_members) do |c|
    c.string  :notification_email
  end

  e.reports('Members', :member_reports, :class => 'person')

  e.dashboard(:primary, :top, :memberships)

  e.nav_section(:members) do |s|
    s.root('Members', :members, 'person')
    s.sub_nav('Index', :member_index)
    s.sub_nav('Activity', :member_activity)
  end

  e.nav_section(:reports) do |s|
    s.sub_nav('Members', :member_reports)
  end
end
