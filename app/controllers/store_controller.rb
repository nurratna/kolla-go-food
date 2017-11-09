class StoreController < ApplicationController
  include CurrentCart
  skip_before_action :authorize
  before_action :set_cart

  def index
    # @foods = Food.order(:name)
    @restaurants = Restaurant.order(:name)
    # @restaurant_name = Restaurant.find_by_name(params[:restaurant_id])
    @foods = Food.all
  end
end
