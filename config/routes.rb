Rails.application.routes.draw do
  mount ActionCable.server => '/chatcable'

  # Devise sign out to destroy the current session
  devise_for :users do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  resources :users, :only => [:show] do
    member do
      get :friends
    end
  end

  get 'friends', to: 'friendships#index', as: 'friends'
  post 'friends/create/:id', to: 'friendships#create', as: 'add_friend'
  put 'friends/accept.:id', to: 'friendships#accept', as: 'accept_request'
  delete 'friends/deny/:id', to: 'friendships#deny', as: 'deny_request'
  delete 'friends/delete/:id', to: 'friendships#destroy', as: 'delete_friend'

  get 'home/index'

  # Redirect the root to the index of the home controller
  root :to => "home#index"

  authenticate do
    resources :discussions
    get 'discussions/subscribe'

    # Specify the custom routes
    get 'global_chat', to: 'global_chat#index'
    get 'global_chat/subscribe'

    get 'contacts/index'
    post 'mail/send', to: 'contacts#send_mail'
    get 'calendar/index'
    get "calendar/data", :to=>"event#get", :as=>"data"
    post "calendar/data(/:id)", :to => "event#add"
    put "calendar/data/:id", :to => "event#update"
    delete "calendar/data/:id", :to => "event#delete"
  end

  %w( 404 422 500 503 ).each do |code|
    get code, :to => "errors#show", :code => code
  end
end
