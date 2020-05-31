class Merchant::OrdersController < ApplicationController

  def show
    @order = Order.find(params[:order_id])
    @merchant = Merchant.find(current_user[:merchant_id])
  end

end
