class Admin::OrdersController < ApplicationController

  def update
    order = Order.find_by(id: params[:order_id])
    order.update(status: "shipped")
    redirect_to "/admin"
  end

  def show
    if current_user == nil || current_user.role != "admin"
      redirect_to "/error404"
    end
    @order = Order.find(params[:order_id])
  end

end
