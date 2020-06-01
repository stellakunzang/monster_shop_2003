class Admin::MerchantsController < ApplicationController

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find_by(id: params[:merchant_id])
  end

  def disable
    merchant = Merchant.find(params[:id])
    merchant.items.each {|item| item.update_attribute(:active?, false)}
    merchant.update_attribute(:active?, false)
    redirect_to "/admin/merchants"
    flash[:notice] = "disabled #{merchant.name}"
  end

  def enable
    merchant = Merchant.find(params[:id])
    merchant.items.each {|item| item.update_attribute(:active?, true)}
    merchant.update_attribute(:active?, true)
    redirect_to "/admin/merchants"
    flash[:notice] = "enabled #{merchant.name}"
  end

end
