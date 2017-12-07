Rails.application.routes.draw do
  devise_for(
    :members,
    :path         => "/members",
    :path_names   => {:sign_in => 'log-in', :sign_out => 'log-out'},
    :password_length => (5..72),
    :controllers  => {
      :sessions => "islay_members/public/sessions",
      :passwords => "islay_members/public/passwords",
      :registrations => 'islay_members/public/registrations'
    }
  )

  islay_admin 'islay_members' do
    resources :members do
      get '(/filter-:filter)(/sort-:sort)', :action => :index, :as => 'filter_and_sort', :on => :collection
      get :delete, :on => :member
    end
  end

  islay_secure_public 'islay_members' do
    scope '/account' do
      get   '/'         => 'members#index',  as: 'member_index'
      get   '/edit'     => 'members#edit',   as: 'member_edit'
      post  '/'         => 'members#update'
      patch '/'         => 'members#update', as: 'member_update'

      resources :addresses, as: 'member_address', controller: 'member_address'
      resources :payment_methods, path: 'payment', as: 'member_payment', controller: 'member_payment_method'
    end

  end

end
