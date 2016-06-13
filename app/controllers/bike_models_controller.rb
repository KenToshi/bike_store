class BikeModelsController < ApplicationController
  before_action :set_bike_model, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token
  
  # GET /bike_models
  # GET /bike_models.json
  def index
    @bike_models = BikeModel.all
  end

  # GET /bike_models/1
  # GET /bike_models/1.json
  def show
  end

  # GET /bike_models/new
  def new
    @bike_model = BikeModel.new
  end

  # GET /bike_models/1/edit
  def edit
  end

  # POST /bike_models
  # POST /bike_models.json
  def create
    @bike_model = BikeModel.new(bike_model_params)

    respond_to do |format|
      if @bike_model.save
        format.html { redirect_to @bike_model, notice: 'Bike model was successfully created.' }
        format.json { render :show, status: :created, location: @bike_model }
      else
        format.html { render :new }
        format.json { render json: [errors: @bike_model.errors], status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bike_models/1
  # PATCH/PUT /bike_models/1.json
  def update
    respond_to do |format|
      if @bike_model.update(bike_model_params)
        format.html { redirect_to @bike_model, notice: 'Bike model was successfully updated.' }
        format.json { render :show, status: :ok, location: @bike_model }
      else
        format.html { render :edit }
        format.json { render json: {errors: @bike_model.errors.full_messages}, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bike_models/1
  # DELETE /bike_models/1.json
  def destroy
    @bike_model.destroy
    respond_to do |format|
      format.html { redirect_to bike_models_url, notice: 'Bike model was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bike_model
      @bike_model = BikeModel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bike_model_params
      params.require(:bike_model).permit(:bike_model_name)
    end
end
