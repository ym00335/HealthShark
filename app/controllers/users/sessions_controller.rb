# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  after_action :notify_pusher_login, only: :create
  before_action :notify_pusher_logout, only: :destroy

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  #

  def notify_pusher_login
    user = User.find(current_user.id)
    user.update(is_signed_in: true)
    notify_pusher 'login'
  end

  def notify_pusher_logout
    user = User.find(current_user.id)
    user.update(is_signed_in: false)
    notify_pusher 'logout'
  end

  def notify_pusher(activity_type)
    Pusher.trigger('activity', activity_type, current_user.as_json)
  end
end
