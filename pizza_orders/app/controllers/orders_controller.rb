class OrdersController < ApplicationController
  def index
    @orders = Order.open.includes(order_items: :pizza).order(created_at: :asc)
  end

  def update
    order = Order.find(params[:id])
    order.completed!
    redirect_to orders_path
  end
end