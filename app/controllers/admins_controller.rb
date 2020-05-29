class AdminsController <ApplicationController

  def index
    @merchants = Merchant.all
  end

  def show
    if current_user == nil || current_user.role != "admin"
      redirect_to "/error404"
    else
      @user = User.find(session[:user_id])
    end
  end

  def create
    new_user = User.new(user_params)
    if new_user.save
      session[:user_id] = new_user.id
      redirect_to "/profile"
    else
      flash.now[:notice] = new_user.errors.full_messages
      render :new
    end
  end

  def disable
    merchant = Merchant.find(params[:id])
    merchant.update_attribute(:active?, false)
    redirect_to "/admin/merchants"
    flash[:notice] = "disabled #{merchant.name}"
  end

  def enable
    merchant = Merchant.find(params[:id])
    merchant.update_attribute(:active?, true)
    redirect_to "/admin/merchants"
    flash[:notice] = "enabled #{merchant.name}"
  end

end
