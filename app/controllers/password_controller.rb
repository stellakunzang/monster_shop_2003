class PasswordController < ApplicationController
  def edit
    @user = User.find(session[:user_id])
  end
end
