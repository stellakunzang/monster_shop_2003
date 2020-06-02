class Merchant::ItemsController < ApplicationController

  def index
    @merchant = Merchant.find(current_user[:merchant_id])
  end

  def destroy
    Item.destroy(params[:id])
    flash[:error] = "Item Deleted"
    redirect_to merchant_items_path
  end

  def status
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

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    params[:price] = params[:price].to_s.gsub(/[$,]/,'').to_f
    @item.update(item_params)
    if @item.image == ""
      @item.default_image
    end
    if @item.save
      flash[:success] = "#{@item.name} has been updated!"
      redirect_to "/merchant/items"
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      redirect_to "/merchant/items/#{@item.id}/edit"
    end
  end

  private

  def item_params
    params.permit(:name,:description,:price,:inventory,:image,:active?)
  end
end
