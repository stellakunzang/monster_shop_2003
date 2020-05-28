
class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def login
  end

  def logout
    redirect_to "/"
  end

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
    if current_user == nil
      redirect_to "/error404"
    else
      @user = User.find(session[:user_id])
    end
  end

  def edit
    @user = User.find(session[:user_id])
  end

  def update
    user = User.find(session[:user_id])
    user.update!(user_params)
    flash[:notice]= "Your data has been updated."
    redirect_to('/profile')
  end
  
  private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password)

  end
end
