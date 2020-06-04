class AdminsController < ApplicationController

  def show
    if current_user == nil || current_user.role != "admin"
      redirect_to "/error404"
    else
      @orders = Order.all
    end
  end
end
