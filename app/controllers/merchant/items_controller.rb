class Merchant::ItemsController < ApplicationController

  def index
    @merchant = Merchant.find(current_user[:merchant_id])
  end

  def update
    if current_user == nil || current_user.role != "merchant"
      redirect_to "/error404"
    else
      item = Item.find(params[:id])
      if item.active? == true
        item.update(active?: false)
        flash[:notice] = "#{item.name} is now inactive!"
      else
        item.update(active?: true)
        flash[:notice] = "#{item.name} is now active!"
      end
      redirect_to "/merchant/items"
    end
  end
end
