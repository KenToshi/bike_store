class InventoryController < ApplicationController
  before_action :constructor
  require 'date'
  skip_before_filter :verify_authenticity_token

  def constructor
    @size = %w[12 14 16 18 20 24 26 27] 
  end  

  def index    
  	@products = Product.all
  end

  def add
    @products = Product.all
  	@stock = Stock.new
  	@stock_history = StockHistory.new
  end

  def check
  	@product = Product.find(params[:id])
  	@stock = Stock.find_by(product_id: @product.id)
  	@stock_histories = StockHistory.where(stock_id: @stock.id)
  end

  def revise
    @products = Product.all
    @stock = Stock.new
    @stock_history = StockHistory.new
  end

  def product_history
    @product = Product.find(history_params[:product])
    @stock = Stock.find_by(product_id: @product.id)

    dummy_start_date = history_params[:start_date] 
    dummy_start_date[0], dummy_start_date[3] = dummy_start_date[3], dummy_start_date[0]
    dummy_start_date[1], dummy_start_date[4] = dummy_start_date[4], dummy_start_date[1]  

    dummy_end_date = history_params[:end_date] 
    dummy_end_date[0], dummy_end_date[3] = dummy_end_date[3], dummy_end_date[0]
    dummy_end_date[1], dummy_end_date[4] = dummy_end_date[4], dummy_end_date[1]  

    start_date = DateTime.parse(dummy_start_date)
    end_date = DateTime.parse(dummy_end_date).tomorrow

    current_stock = @stock.qty
    starting_stock = current_stock
    ending_stock = current_stock

    dummy_history_initial = StockHistory.where(stock_id: @stock.id, created_at: start_date..Date.tomorrow)
    dummy_history_initial.each do |dummy|
      starting_stock -=dummy.alteration
    end

    dummy_history_ending = StockHistory.where(stock_id: @stock.id, created_at: end_date..Date.tomorrow)
    dummy_history_ending.each do |dummy|
      ending_stock -=dummy.alteration
    end

    history_track = StockHistory.where(stock_id: @stock.id, created_at: start_date..end_date)
    @history_track = history_track
    @starting_stock = starting_stock
    @ending_stock = ending_stock
    @start_date = Date.parse(dummy_start_date)
    @end_date = Date.parse(dummy_end_date)

    respond_to do |format|
      #format.json { render json: {starting_stock: starting_stock, ending_stock: ending_stock} }
      format.json { render json: {start_date: dummy_start_date, product_track: history_track,   current_stock: current_stock, starting_stock: starting_stock, ending_stock: ending_stock} }
      format.pdf {
        render pdf: "Stock History #{@product.bike_name} Period #{start_date} to #{end_date}",
        template: "inventory/stock_track.pdf.html.erb"
      }
    end
  end

  private
    def history_params
      params.permit(:start_date, :end_date, :product)
    end
end
