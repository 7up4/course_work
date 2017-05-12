class RoutesController < ApplicationController
  before_action :set_route, only: [:show, :edit, :update, :destroy]
  before_action -> {check_permissions('admin', 'operator')}, except: [:show, :index]
  # GET /routes
  # GET /routes.json
  def index
    @routes = Route.all
  end

  def search
    @routes = params.has_key?(:search) ? Route.search(params[:search]) : @routes = []
    respond_to do |format|
      format.js
      format.html
    end
  end
  
  # GET /routes/1
  # GET /routes/1.json
  def show
  end

  # GET /routes/new
  def new
    @route = Route.new
  end

  # GET /routes/1/edit
  def edit
  end

  def fill_nested_station
    if !params[:station_to_fill].first.blank?
      @station = Station.where("id= ?", params[:station_to_fill].first).first
    else
      @station = nil
    end
    @nested_form_name = params[:station_to_fill].second
    respond_to do |format|
      format.js
    end
  end

  # POST /routes
  # POST /routes.json
  def create
    @route = Route.new(route_params)
    respond_to do |format|
      @route.validate
      if (@route.errors.keys - [:start_station_id, :end_station_id]).size == 0
        @route.save(validate: false)
      end
      if @route.save
        format.html { redirect_to @route, notice: 'Маршрут создан.' }
        format.json { render :show, status: :created, location: @route }
      else
        format.html { render :new }
        format.json { render json: @route.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /routes/1
  # PATCH/PUT /routes/1.json
  def update
    respond_to do |format|
      @route.attributes = route_params
      @route.validate
      if (@route.errors.keys - [:start_station_id, :end_station_id]).size == 0
        @route.save(validate: false)
      end
      if @route.save
        format.html { redirect_to @route, notice: 'Маршрут обновлён.' }
        format.json { render :show, status: :ok, location: @route }
      else
        format.html { render :edit }
        format.json { render json: @route.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /routes/1
  # DELETE /routes/1.json
  def destroy
    @route.destroy
    respond_to do |format|
      format.html { redirect_to routes_url, notice: 'Маршрут удалён.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_route
      @route = Route.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def route_params
      params.require(:route).permit(
        :start_station_id, :end_station_id, :mon, :tues, :wed, :thurs, :fri, :sat, :sun,
        route_stations_attributes: [:id, :arrival_time, :is_missed, :station_id, :_destroy, station_attributes: [:id, :name, :number, :tariff_zone_id, :_destroy, tariff_zone_attributes: [:id, :name, :_destroy]]],
        search: [
          route: [:start_station, :end_station, :mon, :tues, :wed, :thurs, :fri, :sat, :sun],
          route_station: [:arrival_time, :is_missed],
          station: [:name, :number], 
          tariff_zone: [:name]
        ]
      )
    end
end
