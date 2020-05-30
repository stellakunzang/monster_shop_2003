class CartController < ApplicationController
  def add_item
    if current_user == nil || current_user.role != "admin"
      item = Item.find(params[:item_id])
      cart.add_item(item.id.to_s)
      flash[:success] = "#{item.name} was successfully added to your cart"
      redirect_to "/items"
    else
      redirect_to "/error404"
    end
  end

  def show
    if current_user == nil || current_user.role != "admin"
      @items = cart.items
    else
      redirect_to "/error404"
    end
  end

  def empty
    if current_user == nil || current_user.role != "admin"
      session.delete(:cart)
      redirect_to '/cart'
    else
      redirect_to "/error404"
    end
  end

  def remove_item
    if current_user == nil || current_user.role != "admin"
      session[:cart].delete(params[:item_id])
      redirect_to '/cart'
    else
      redirect_to "/error404"
    end
  end

  def update_quantity
    item_id = params[:item_id]
    # TODO: can only add to quantity if we have enough inventory 
    # a boolean to indicate whether or not there is enough inventory 
    # to add one to the cart
    has_inventory = Item.find(item_id).inventory >= 0 
    # require 'pry', binding.pry
    if params[:add] == "true" && has_inventory
      flash[:success] = "You have changed your cart quantity."
      cart.contents[item_id] += 1
    elsif params[:add] == "true" && !has_inventory
      flash[:error] = "Not enough in inventory"
      redirect_to '/cart'
    elsif params[:add] == "false"
      flash[:success] = "You have changed your cart quantity."
      cart.contents[item_id] -= 1
    end

    redirect_to '/cart'
  end


end
