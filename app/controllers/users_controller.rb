class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    if @user == current_user
      redirect_to edit_user_registration_path
    end
  end
end