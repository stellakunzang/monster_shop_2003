class Admin::MerchantsController < ApplicationController

  def show
    @merchant = Merchant.find_by(id: params[:merchant_id])
  end

end
