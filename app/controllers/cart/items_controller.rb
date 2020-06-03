class Cart::ItemsController < ApplicationController

  def new
    if current_user == nil || current_user.role != "admin"
      item = Item.find(params[:item_id])
      item_inventory = item.inventory

      has_inventory = item_inventory > 0
      if has_inventory
        cart.add_item(item.id.to_s)
        item.update(inventory: item_inventory - 1)
        flash[:success] = "#{item.name} was successfully added to your cart"
      else
        flash[:error] = "Not enough in inventory"
      end

      redirect_to "/items"
    else
      redirect_to "/error404"
    end
  end

  def update
    item_id = params[:item_id]
    item = Item.find(item_id)
    item_inventory = item.inventory

    has_inventory = item_inventory > 0
    if params[:add] == "true" && has_inventory
      flash[:success] = "You have changed your cart quantity."
      cart.contents[item_id] += 1
      item.update(inventory: item_inventory - 1)
    elsif params[:add] == "true" && !has_inventory
      flash[:error] = "Not enough in inventory"
    elsif params[:add] == "false"
      flash[:success] = "You have changed your cart quantity."
      if cart.contents[item_id] == 0
        session[:cart].delete(params[:item_id])
        flash[:error] = "Item removed"
      else
        flash[:success] = "You have changed your cart quantity."
        cart.contents[item_id] -= 1
        item.update(inventory: item_inventory + 1)
      end
    end

    redirect_to '/cart'
  end

  def destroy
    if current_user == nil || current_user.role != "admin"
      session[:cart].delete(params[:item_id])
      redirect_to '/cart'
    else
      redirect_to "/error404"
    end
  end
end
