class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :constructor

  skip_before_filter :verify_authenticity_token

  def constructor
    @size = %w[12 14 16 18 20 24 26 27]
    @models = BikeModel.all
    @qty = 0
  end

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  def cek
  end

  # GET /products/new
  def new
    @qty = 0
    @stock = Stock.new
    @product = Product.new
    
  end

  # GET /products/1/edit
  def edit
    # @bike = @product[:bike_model_id]
  end

  # POST /products
  # POST /products.json
  def create
   @product = Product.new(product_params)
   @qty = stock_params[:qty].to_i

   respond_to do |format|

      if(@product.save)

      @stock = Stock.new
      @stock.product_id = @product.id
      @stock.qty = @qty
      
      if(@stock.save)
        @stock_history = StockHistory.new
        @stock_history.stock_id = @stock.id
        @stock_history.alteration = @stock.qty
        @stock_history.description = "Initial Stock"
        @stock_history.save

      else
        @product.delete
        format.html { render :new }
        format.json { render json: {errors: @stock.errors}, status: :unprocessable_entity }

      end

      format.html { redirect_to @product, notice: 'Product was successfully created.' }
      format.json { render :show, status: :created, location: @product }
     else

      format.html { render :new }
      format.json { render json: {errors: @product.errors}, status: :unprocessable_entity }
     end


    end 
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(update_product_params)
        format.html { redirect_to request.referer, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: {errors: @product.errors}, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to request.referer, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
      @stock = Stock.new
      @qty = 0
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      # @bike_model_id = BikeModel.find_by(bike_model_name: :bike_model_id).id

      params.require(:product).permit(:bike_name, :bike_model_id, :price, :bike_size)
    end

    def stock_params
      params.require(:stock).permit(:qty)
    end

    def update_product_params
        params.require(:product).permit(:price)
    end
end
