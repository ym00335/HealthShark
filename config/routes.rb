Rails.application.routes.draw do

  mount ActionCable.server => '/chatcable'

  # Devise sign out to destroy the current session
  devise_for :users do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  get 'home/index'

  # Redirect the root to the index of the home controller
  root :to => redirect('home/index')

  authenticate do
    # Specify the custom routes
    get 'chat/index'
    get 'chat/subscribe'
    get 'contacts/index'
    post 'mail/send', to: 'contacts#send_mail'
  end
end
