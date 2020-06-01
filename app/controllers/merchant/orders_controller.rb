class Merchant::OrdersController < ApplicationController

  def show
    @order = Order.find(params[:order_id])
    @merchant = Merchant.find(current_user[:merchant_id])
  end

  def update
    order = Order.find(params[:order_id])
    item_order = ItemOrder.find(params[:item_order_id])
    updated_inventory = item_order.item.inventory - item_order.quantity
    item_order.item.update_attributes(inventory: updated_inventory)
    item_order.fulfill
    flash[:success] = "#{item_order.item.name} from order #{order.id} has been fulfilled."
    redirect_to("/merchant/orders/#{order.id}")
  end

end
