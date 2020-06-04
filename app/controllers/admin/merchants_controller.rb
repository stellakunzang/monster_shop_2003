class Admin::MerchantsController < ApplicationController

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find_by(id: params[:merchant_id])
  end

  def update
    @merchant = Merchant.find(params[:id])
    if @merchant.active? == true
      @merchant.items.each {|item| item.update_attribute(:active?, false)}
      @merchant.update_attribute(:active?, false)
      redirect_to "/admin/merchants"
      flash[:notice] = "disabled #{@merchant.name}"
    else
      @merchant.items.each {|item| item.update_attribute(:active?, true)}
      @merchant.update_attribute(:active?, true)
      redirect_to "/admin/merchants"
      flash[:notice] = "enabled #{@merchant.name}"
    end
  end
end
