class RoutesController < ApplicationController
  before_action :set_route, only: [:show, :edit, :update, :destroy]
  after_action :set_arrival_time, only: [:update, :create]

  # GET /routes
  # GET /routes.json
  def index
    @routes = Route.all
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

  # POST /routes
  # POST /routes.json
  def create
    @route = Route.new(route_params)
    respond_to do |format|
      if @route.save
        format.html { redirect_to @route, notice: 'Route was successfully created.' }
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
      if @route.update(route_params)
        format.html { redirect_to @route, notice: 'Route was successfully updated.' }
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
      format.html { redirect_to routes_url, notice: 'Route was successfully destroyed.' }
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
      params.require(:route).permit(:start_station_id, :end_station_id, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday,
      arrival_time: [:id, :year, :month, :day,  :hour, :minute])
    end

    def set_arrival_time
      @route.stations.each do |s|
        rs=s.route_stations.where(station_id: s, route_id: @route)
        t=Time.new(
          params[:arrival_time][s.id.to_s]["year"],
          params[:arrival_time][s.id.to_s]["month"],
          params[:arrival_time][s.id.to_s]["day"],
          params[:arrival_time][s.id.to_s]["hour"],
          params[:arrival_time][s.id.to_s]["minute"]
        )
        rs.update_all(:arrival_time=> t)
      end
    end
end
