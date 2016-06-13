class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :constructor

  skip_before_filter :verify_authenticity_token
  
  def constructor
    
  end

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @order_items = OrderItem.where(order_id: @order.id)
  end

  def retrieve_cart
    @order = Order.find_by_id(params[:id])

    if(@order)
      @order_items = OrderItem.where(order_id: @order.id)
      respond_to do |format|
        format.json { render :item, status: :ok}
      end
    else
      respond_to do |format|
        format.json { render json: {errors: "Order ID not found"}, status: :ok}
      end
    end

  end

  # GET /orders/new
  def new
    @order = Order.new
    @customer = Customer.new
  end

  # GET /orders/1/edit
  def edit
    @customer = Customer.find_by(id: @order.customer_id)

  end

  def verify_order
    @order = Order.find_by_id(order_params[:id])
    @order_items = OrderItem.where(:order_id => @order.id)

    puts @order.status

    if (@order.pre_order? )

        if @order_items.count == 0 # cart is empty
          respond_to do |format|
              format.json { render json: {message: "The shopping cart is empty, please put some before proceeding"}, status: :unprocessable_entity }
          end
        else  #cart is not empty
          verified = true
          @order_items.each do |item| # check whether all items are available
            checked_product = Product.find_by_id(item.product_id)
            checked_stock = Stock.find_by(product_id: checked_product.id)            

            if checked_stock.qty < item.qty # if the stock is insufficient
              verified = false # then we cannot proceed the checkout
            end

          end # end of checking

          if verified # if all stock is available
            @order.active_order!

            @order_items.each do |item| # remake tapi udah jalan
              checked_product = Product.find_by_id(item.product_id)
              checked_stock = Stock.find_by(product_id: checked_product.id)        

              # Creates Documentation
              stock_history = StockHistory.new
              stock_history.stock_id = checked_stock.id
              stock_history.alteration = item.qty*-1
              stock_history.description = "Ordered by "+@order.customer.customer_name.to_s+" on order #"+@order.id.to_s

              # Edit Current Stock
              checked_stock.qty = checked_stock.qty - item.qty

              # Save changes
              stock_history.save
              checked_stock.save 
            end #

            @order.order_date = Date.today
            @order.save
            respond_to do |format|
              format.json { render json: {message: "The order is being processed"}, status: :ok }
            end

          else # one or more stock is short on stock
            respond_to do |format|
              format.json { render json: {message: "One or more bikes in the cart is unsufficient" }, status: :unprocessable_entity }
            end
          end

        end
    else # the order is already verified
      respond_to do |format|
        format.json { render json: {message: "The order is already verified"}, status: :unprocessable_entity }
      end
    end
  end

  def confirm_payment
    @order = Order.find(order_params[:id])

    shipping_date = order_params[:shipping_date]
    shipping_address = order_params[:shipping_address]
    shipping_method = order_params[:shipping_method]

    print = true
    if (@order.pre_order?) # if the order hasn't verified, they cannot pay
      print = false
      respond_to do |format|
        format.json { render json: {errors: "The order is not verified yet"}, status: :unprocessable_entity }
      end
    elsif (@order.cancelled?)
      print = false
      respond_to do |format|
        format.json { render json: {errors: "Cannot update cancelleded order"}, status: :unprocessable_entity }
      end
    elsif (@order.active_order?)
      if !@order.is_delivered
        @order.shipping_date = shipping_date
        @order.shipping_address = shipping_address
        @order.shipping_method = shipping_method
      end

      @order.is_paid = true
      @order.payment_date = Date.today

      if ((@order.is_paid)&&(@order.is_delivered))
        @order.finished!
      end

      @order.save

    end  

    if print
      respond_to do |format|
        format.json { render json: {message: "Payment confirmation succeeded"}, status: :ok}
      end
    end
  end

  def confirm_delivery
    @order = Order.find(order_params[:id])

    shipping_date = order_params[:shipping_date]
    shipping_address = order_params[:shipping_address]
    shipping_method = order_params[:shipping_method]

    print = true
    if (@order.pre_order?) # if the order hasn't verified, they cannot deliver
      print = false
      respond_to do |format|
        format.json { render json: {errors: "The order is not verified yet"}, status: :unprocessable_entity }
      end
    elsif (@order.cancelled?)
      print = false
      respond_to do |format|
        format.json { render json: {errors: "Cannot update cancelleded order"}, status: :unprocessable_entity }
      end
    
    elsif (@order.active_order?)

      @order.shipping_date = shipping_date
      @order.shipping_address = shipping_address
      @order.shipping_method = shipping_method

      if ( (@order.is_paid) && (@order.shipping_date.present?) && (@order.shipping_address.present?) && (@order.shipping_method.present?))
        @order.is_delivered = true
      else
        print = false
        respond_to do |format|
          format.json { render json: {errors: "Please fill all shipping details and payment before confirm shipment"}, status: :unprocessable_entity}
        end
      end
    
      if ((@order.is_paid)&&(@order.is_delivered))
        @order.finished!
      end

      @order.save
      
    end  

    if print
      respond_to do |format|
        format.json { render json: {message: "Deliver Confirmation Succeeded"}, status: :ok}
      end
    end
  end

  # POST /orders
  # POST /orders.json
  def create
     ok = true
     @customer = Customer.find_by_id(customer_params[:id])
     if(@customer==nil)
        respond_to do |format|
          format.json { render json: {errors: "Customer not found"}, status: :unprocessable_entity }
        end
    end
    if(ok)
      @order = Order.new()
      @order.customer_id = @customer.id
      
      respond_to do |format|
        if @order.save
          format.json { render :show, status: :created, location: @order }
        else
          format.json {render json: {errors: @order.errors}, status: :unprocessable_entity }
        end
      end
    end
  end

  def invoice
    @order = Order.find(params[:id])

    if @order.is_paid
      respond_to do |format|
        format.pdf do
          render pdf: "Invoice ##{@order.id}",
            template: "orders/invoice.html.erb"
        end
      end
    else
      render json: {errors: "The order is not paid"}, status: :unprocessable_entity
    end

  end

  def letter_of_travel
    @order = Order.find(params[:id])

    if @order.is_paid
      respond_to do |format|
        format.pdf do
          render pdf: "Letter of Travel ##{@order.id}",
            template: "orders/letter_of_travel.html.erb"
        end
      end
    else
      render json: {errors: "The order is not delivered"}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    @order = Order.find(params[:id])
    if((@order.active_order?)&&(!@order.is_delivered))
      puts @order.shipping_date

      @order.shipping_method = order_details_params[:shipping_method]
      @order.shipping_address = order_details_params[:shipping_address]

      dummy_shipping_date = order_details_params[:shipping_date] 

      if(dummy_shipping_date.present?)
        dummy_shipping_date[0], dummy_shipping_date[3] = dummy_shipping_date[3], dummy_shipping_date[0]
        dummy_shipping_date[1], dummy_shipping_date[4] = dummy_shipping_date[4], dummy_shipping_date[1]  

        @order.shipping_date = DateTime.parse(dummy_shipping_date)
      else
      
      end
      puts @order.shipping_date
      @order.save
    end

    respond_to do |format|
      format.json {render json: {message: "Order Details has been saved"}, status: :ok }
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @user=  User.find(session[:user_id])
    if ((@user)&&(@user.user_type=="Admin"))
      if ((!@order.finished?) || (!@order.cancelled?))
        if @order.active_order?
            @order_items = OrderItem.where(:order_id => @order.id)

            @order_items.each do |item| # remake tapi udah jalan
              checked_product = Product.find_by_id(item.product_id)
              checked_stock = Stock.find_by(product_id: checked_product.id)        

              # Creates Documentation
              stock_history = StockHistory.new
              stock_history.stock_id = checked_stock.id
              stock_history.alteration = item.qty
              stock_history.description = "Order Cancelled by "+@order.customer.customer_name.to_s+" on order #"+@order.id.to_s

              # Edit Current Stock
              checked_stock.qty = checked_stock.qty + item.qty

              # Save changes
              stock_history.save
              checked_stock.save 
            end #
        end

        @order.cancelled!
  
        @order.save
        respond_to do |format|
          format.json { render json: {message: "The order is cancelled"}, status: :ok }
        end
      else
        respond_to do |format|
          format.json { render json: {message: "Cannot cancelled finished order"}, status: :unprocessable_entity }
        end
      end
    else # not admin
      respond_to do |format|
        format.json { render json: {message: "Only admin can delete orders"}, status: :unprocessable_entity }
      end
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:id, :order_date, :is_paid, :payment_date, :is_delivered,:shipping_address, :shipping_method, :shipping_date, :receipt_number)
    end

    def customer_params
      params.require(:customer).permit(:id, :customer_name, :customer_address, :customer_phone)
    end  

    def order_details_params
      params.require(:order).permit(:shipping_method, :shipping_date, :shipping_address)
    end
end
