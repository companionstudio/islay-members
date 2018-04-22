Rails.application.routes.draw do
  devise_for(
    :members,
    :path         => "/members",
    :path_names   => {:sign_in => 'log-in', :sign_out => 'log-out'},
    :password_length => (5..72),
    :controllers  => {
      :sessions      => 'islay_members/public/sessions',
      :passwords     => 'islay_members/public/passwords',
      :registrations => 'islay_members/public/registrations',
      :confirmations => 'islay_members/public/confirmations'

    }
  )

  islay_admin 'islay_members' do

    get '/club' => 'club#index', as: 'club_dashboard'

    resources :members do
      get '(/filter-:filter)(/sort-:sort)', :action => :index, :as => 'filter_and_sort', :on => :collection
      get :delete, :on => :member

      resources :subscriptions do
        get '(/filter-:filter)(/sort-:sort)', :action => :index, :as => 'filter_and_sort', :on => :collection
        get :delete, :on => :member
      end
    end

    resources :series do
      get '(/filter-:filter)(/sort-:sort)', :action => :index, :as => 'filter_and_sort', :on => :collection
      get :delete, :on => :member
    end

    range = "(/month-:year-:month)(/range/:from/:to)"

    scope :path => 'reports/members', :controller => 'reports' do
      get range, :action => :index,    :as => 'member_reports'
    end
  end

  islay_secure_public 'islay_members' do
    scope '/account' do
      get   '/'         => 'members#index',  as: 'member_index'
      get   '/edit'     => 'members#edit',   as: 'member_edit'
      post  '/'         => 'members#update'
      patch '/'         => 'members#update', as: 'member_update'

      get   '/subscription'     => 'members#subscription',   as: 'member_subscription'
      patch '/subscription'     => 'members#subscription',   as: 'member_subscription_update'

      resources :addresses,       as: 'member_address', controller: 'member_address'
      resources :payment_methods, as: 'member_payment', controller: 'member_payment_method', path: 'payment'
      resources :orders,          as: 'member_orders',  controller: 'member_orders', :only => [:index, :show, :edit, :update]

      patch :skip_offer_order,              controller: 'member_offer_orders'
      patch :adjust_offer_order_quantities, controller: 'member_offer_orders'

    end

  end

end
