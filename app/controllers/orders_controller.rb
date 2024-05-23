class OrdersController < ApplicationController
  skip_forgery_protection
  before_action :only_buyers!, :authenticate!

  def create
    @order = Order.new(order_params) { |o| o.buyer = current_user }
    if @order.save
      render :create, status: :created
    else
      render json: {errors: @order.errors, status: :unprocessable_entity}
    end
  end

  def index
    @orders = Order.where(buyer: current_user)
  end

  private

  def order_params
    params.require(:order).permit([:store_id])
  end
end
