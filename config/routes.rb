Rails.application.routes.draw do
  constraints :protocol => secure_protocol do
    devise_for(
      :members,
      :path         => "/",
      :path_names   => {:sign_in => 'login', :sign_out => 'logout'},
      :controllers  => {:sessions => "islay_members/members/sessions", :passwords => "islay_members/members/passwords" }
    )
  end

  islay_admin 'islay_members' do
    resources :members do
      get '(/filter-:filter)(/sort-:sort)', :action => :index, :as => 'filter_and_sort', :on => :collection
      get :delete, :on => :member
    end
  end

  islay_secure_public 'islay_members' do
    get '/club' => 'members#index'
    post '/join' => 'members#create'
  end

end
