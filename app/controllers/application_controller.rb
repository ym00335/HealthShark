class ApplicationController < ActionController::Base
  # Set the default protection
  protect_from_forgery with: :exception

  # Configure the permitted parameters for the devise before each action
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :ensure_domain

  APP_DOMAIN = 'www.health-shark.co.uk'

  def ensure_domain
    if Rails.env.production? && request.env['HTTP_HOST'] != APP_DOMAIN
      # HTTP 301 is a "permanent" redirect
      redirect_to "https://#{APP_DOMAIN}", :status => 301
    end
  end

  # Clears all cache on the front-end
  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  # Display the home index with not found status and flash an alert.
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :name) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:email, :password, :password_confirmation, :current_password, :name, :is_female, :date_of_birth, :image) }
  end
end
