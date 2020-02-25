Rails.application.routes.draw do

  # Specify the custom routes
  get 'home/index'
  get 'contacts/index'
  post 'mail/send', to: 'contacts#send_mail'

  # Devise sign out to destroy the current session
  devise_for :users do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  # Redirect the root to the index of the home controller
  root :to => redirect('home/index')
end
