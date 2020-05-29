class MerchController <ApplicationController
  def show
    if current_user == nil || current_user.role != "merchant"
      redirect_to "/error404"
    else
      @merchant = User.find_by(id: session[:user_id])&.merchant
      @orders = @merchant.orders_with_my_items 
    end
  end
end
