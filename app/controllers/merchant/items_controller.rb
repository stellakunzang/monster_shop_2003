class Merchant::ItemsController < ApplicationController

  def index
    @merchant = Merchant.find(current_user[:merchant_id])
  end

  def destroy
    Item.destroy(params[:id])
    flash[:error] = "Item Deleted"
    redirect_to merchant_items_path
  end
end
