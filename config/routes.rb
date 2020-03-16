Rails.application.routes.draw do
  mount ActionCable.server => '/chatcable'

  # Devise sign out to destroy the current session
  devise_for :users do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  get 'home/index'

  # Redirect the root to the index of the home controller
  root :to => "home#index"

  authenticate do
    resources :discussions, :logs

    # Specify the custom routes
    get 'global_chat/index'
    get 'global_chat/subscribe'

    get 'discussions/subscribe'

    get 'contacts/index'
    post 'mail/send', to: 'contacts#send_mail'
  end

  %w( 404 422 500 503 ).each do |code|
    get code, :to => "errors#show", :code => code
  end
end
