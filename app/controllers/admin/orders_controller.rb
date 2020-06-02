class Admin::OrdersController < ApplicationController

  def update
    order = Order.find_by(id: params[:order_id])
    order.update(status: "shipped")
    redirect_to "/admin"
  end

end
