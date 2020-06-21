class Admin::MerchantsController < ApplicationController

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find_by(id: params[:id])
  end

  def update
    @merchant = Merchant.find(params[:id])
    if @merchant.active? == true
      Item.where(merchant_id: params[:id]).update(active?: false)
      @merchant.update_attribute(:active?, false)
      redirect_to "/admin/merchants"
      flash[:notice] = "disabled #{@merchant.name}"
    else
      Item.where(merchant_id: params[:id]).update(active?: true)
      @merchant.update_attribute(:active?, true)
      redirect_to "/admin/merchants"
      flash[:notice] = "enabled #{@merchant.name}"
    end
  end
end
