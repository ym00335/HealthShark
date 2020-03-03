class ApplicationController < ActionController::Base
  # Set the default protection
  protect_from_forgery with: :exception

  # Configure the permitted parameters for the devise before each action
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Display the home index with not found status and flash an alert.
  def not_found
    flash[:alert] = I18n.t('controllers.not_found')
    redirect_to root_path, :status => :not_found and return
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :name) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:email, :password, :password_confirmation, :current_password, :name, :is_female, :date_of_birth, :image) }
  end
end
