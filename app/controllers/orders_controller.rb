class OrdersController < ApplicationController
  include CurrentCart
  skip_before_action :authorize, only: [:new, :create]
  before_action :set_cart, only: [:new, :create]
  before_action :cart_not_empty, only: [:new]
  before_action :set_order, only: [:show, :edit, :update, :destroy]


  # GEt /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  def show
  end

  # GET /carts/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /carts
  # POST /carts.json
  def create
    @order = Order.new(order_params)
    @order.add_line_items(@cart)
    @order.voucher = Voucher.find_by(code: order_params[:code])
    # @order.voucher = Voucher.find_by(order_params[:code])

    respond_to do |format|
      if @order.save
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil

        OrderMailer.received(@order).deliver_later

        format.html { redirect_to store_index_path, notice: 'Cart was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Cart was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carts/1
  # DELETE /carts/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to @order, notice: 'Order was successfully destroy.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:name, :address, :email, :payment_type, :code)
    end

    def cart_not_empty
      if @cart.line_items.empty?
        redirect_to 'store_index_path', notice: 'Your cart is empty'
      end
    end
end
