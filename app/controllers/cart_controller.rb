class CartController < ApplicationController

  def show
    if current_user == nil || current_user.role != "admin"
      @items = cart.items
    else
      redirect_to "/error404"
    end
  end

  def destroy
    session.delete(:cart)
    redirect_to '/cart'
  end
end
