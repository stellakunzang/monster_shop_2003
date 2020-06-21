class Merchant::OrdersController < ApplicationController

  def show
    @order = Order.find(params[:id])
    @merchant = Merchant.find(current_user[:merchant_id])
  end

  def update
    order = Order.find(params[:id])
    item_order = ItemOrder.find(params[:item_order_id])
    item_order.item.update_inventory(item_order.quantity)
    item_order.fulfill
    if order.totally_fulfilled?
      order.update(status: "packaged")
    end
    flash[:success] = "#{item_order.item.name} from order #{order.id} has been fulfilled."
    redirect_to("/merchant/orders/#{order.id}")
  end

end
