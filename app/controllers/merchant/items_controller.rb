class Merchant::ItemsController < ApplicationController

  def index
    @merchant = Merchant.find(current_user[:merchant_id])
  end

  def destroy
    Item.destroy(params[:id])
    flash[:error] = "Item Deleted"
    redirect_to merchant_items_path
  end

  def new
    @merchant = Merchant.find(current_user[:merchant_id])
  end

  def create
    @merchant = Merchant.find(current_user[:merchant_id])
    item = @merchant.items.create(item_params)
    if item.save
      flash[:success] = "Nailed it!"
      redirect_to "/merchant/items"
    else
      flash[:error] = item.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def item_params
    params.permit(:name,:description,:price,:inventory,:image)
  end
end
