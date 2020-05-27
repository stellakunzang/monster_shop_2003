
class UsersController < ApplicationController
  def login
  end

  def register

class UsersController<ApplicationController
  def new
  end

  def create
    new_user = User.new(user_params)
    if new_user.save
      session[:user_id] = new_user.id
      redirect_to "/profile"
    else
      flash.now[:notice] = new_user.errors.full_messages
      render :new
    end
  end

  def show
    @user = User.find(session[:user_id])
  end

  private

  def user_params
    params.permit(:name,:address,:city,:state,:zip, :email,:password)

  end
end
