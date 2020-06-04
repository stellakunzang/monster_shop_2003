class MerchantsItemsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def new
    if current_user == nil || current_user.role != "merchant"
        redirect_to "/error404"
    else
      @merchant = Merchant.find(params[:merchant_id])
    end
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    item = @merchant.items.create(item_params)
    if item.save
      redirect_to "/merchants/#{@merchant.id}/items"
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
