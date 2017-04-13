require 'test_helper'

class TariffZonesControllerTest < ActionController::TestCase
  setup do
    @tariff_zone = tariff_zones(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tariff_zones)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tariff_zone" do
    assert_difference('TariffZone.count') do
      post :create, tariff_zone: { name: @tariff_zone.name }
    end

    assert_redirected_to tariff_zone_path(assigns(:tariff_zone))
  end

  test "should show tariff_zone" do
    get :show, id: @tariff_zone
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tariff_zone
    assert_response :success
  end

  test "should update tariff_zone" do
    patch :update, id: @tariff_zone, tariff_zone: { name: @tariff_zone.name }
    assert_redirected_to tariff_zone_path(assigns(:tariff_zone))
  end

  test "should destroy tariff_zone" do
    assert_difference('TariffZone.count', -1) do
      delete :destroy, id: @tariff_zone
    end

    assert_redirected_to tariff_zones_path
  end
end
