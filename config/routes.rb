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

    get   '/club' => 'members#index'

    scope '/members' do
      get   '/'         => 'members#index'
      get   '/offers'   => 'members#offers'
      get   '/orders'   => 'members#orders'

      resources :addresses, as: 'member_address', controller: 'member_address'
      # scope '/address', controller: 'member_address', as: 'member_address' do
      #   get    '/',       action: 'index'
      #   get    '/new',    action: 'new'
      #   post   '/create', action: 'create'
      #   get    '/:id',    action: 'edit'
      #   patch  '/:id',    action: 'update'
      #   put    '/:id',    action: 'update'
      #   delete '/:id',    action: 'delete'
      # end
    end



  end

end
