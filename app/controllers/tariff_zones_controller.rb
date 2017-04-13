class TariffZonesController < ApplicationController
  before_action :set_tariff_zone, only: [:show, :edit, :update, :destroy]

  # GET /tariff_zones
  # GET /tariff_zones.json
  def index
    @tariff_zones = TariffZone.all
  end

  # GET /tariff_zones/1
  # GET /tariff_zones/1.json
  def show
  end

  # GET /tariff_zones/new
  def new
    @tariff_zone = TariffZone.new
  end

  # GET /tariff_zones/1/edit
  def edit
  end

  # POST /tariff_zones
  # POST /tariff_zones.json
  def create
    @tariff_zone = TariffZone.new(tariff_zone_params)

    respond_to do |format|
      if @tariff_zone.save
        format.html { redirect_to @tariff_zone, notice: 'Tariff zone was successfully created.' }
        format.json { render :show, status: :created, location: @tariff_zone }
      else
        format.html { render :new }
        format.json { render json: @tariff_zone.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tariff_zones/1
  # PATCH/PUT /tariff_zones/1.json
  def update
    respond_to do |format|
      if @tariff_zone.update(tariff_zone_params)
        format.html { redirect_to @tariff_zone, notice: 'Tariff zone was successfully updated.' }
        format.json { render :show, status: :ok, location: @tariff_zone }
      else
        format.html { render :edit }
        format.json { render json: @tariff_zone.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tariff_zones/1
  # DELETE /tariff_zones/1.json
  def destroy
    @tariff_zone.destroy
    respond_to do |format|
      format.html { redirect_to tariff_zones_url, notice: 'Tariff zone was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tariff_zone
      @tariff_zone = TariffZone.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tariff_zone_params
      params.require(:tariff_zone).permit(:name)
    end
end
