class OrderItemsController < ApplicationController
  before_action :set_order_item, only: [:edit, :update, :destroy]
  before_action :load_products, only: [:new, :update, :edit]

  skip_before_filter :verify_authenticity_token

  # GET /order_items
  # GET /order_items.json
  def index
    @order_items = OrderItem.all
  end

  # GET /order_items/1
  # GET /order_items/1.json
  def show
    @order_item = OrderItem.find(order_id: params[:id])
  end

  # GET /order_items/new
  def new
    @order = Order.find_by(id: params[:order_id])
    @product = Product.find_by_id(params[:product_id])
    puts params[:orderID]
    @order_item = OrderItem.new
  end

  # GET /order_items/1/edit
  def edit

  end

  # POST /order_items
  # POST /order_items.json
  def create
    order = Order.find_by_id(order_item_params[:order_id])
    product =  Product.find_by_id(order_item_params[:product_id])
    qty = order_item_params[:qty].to_i

    if (product)
      if (order.pre_order?)

        if(!OrderItem.exists?(:order_id => order.id, :product_id => product.id))
          
            @order_item = OrderItem.new()

            price = product.price

            # masukin dalam datanya
            @order_item.order_id = order.id
            @order_item.product_id = product.id
            @order_item.qty = qty
            @order_item.price = price

            respond_to do |format|

              if @order_item.save
                puts "XYYXY"
                format.json { render :show, status: :created}
              else
                puts @order_item.errors
                format.json { render json: {errors: @order_item.errors} , status: :unprocessable_entity }
              end

            end

          else # if the product existed in the cart

            @order_item = OrderItem.find_by(:order_id => order.id, :product_id => product.id)
            price = @order_item.product.price

            @order_item.qty = qty
            @order_item.price = price

            respond_to do |format|
              if @order_item.save
                format.json { render :show, status: :created}
              else
                format.json { render json: {errors: @order_item.errors} , status: :unprocessable_entity}
              end

            end

          end
      else # the order is already verified 

        respond_to do |format|
          format.json { render json: {errors: "The order is already verified"} , status: :unprocessable_entity }        
        end
      end

    else # product not found 
      respond_to do |format|
        format.json {render json: {errors: {product_id: "cannot be empty"}}, status: :unprocessable_entity}
      end
    end
    

  end

  # PATCH/PUT /order_items/1
  # PATCH/PUT /order_items/1.json
  # def update
  #   respond_to do |format|
  #     if @order_item.update(order_item_params)
  #       format.html { redirect_to @order_item, notice: 'Order item was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @order_item }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @order_item.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /order_items/1
  # DELETE /order_items/1.json
  def destroy
    order_item = OrderItem.find_by_id(params[:id])
    if(order_item)
      order = Order.find_by_id(order_item.order)
      if order.pre_order? # the order haven't verified
        order_item.destroy
        respond_to do |format|
          format.json { render json: {message: "Order Item successfully deleted!"}, status: :ok }
        end
      else # the order is already verified
        respond_to do |format|
          format.json { render json: {message: "Cannot delete verified order!"}, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
          format.json { render json: {message: "Order Item not found"}, status: :unprocessable_entity }
      end
    end
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order_item
      @order_item = OrderItem.find(params[:id])
      
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_item_params
      params.require(:order_item).permit(:product_id, :order_id, :qty)
    end

    def load_products
      @products = Product.all
    end
end
