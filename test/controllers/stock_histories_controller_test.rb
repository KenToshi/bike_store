require 'test_helper'

class StockHistoriesControllerTest < ActionController::TestCase
  setup do
    @stock_history = stock_histories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stock_histories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stock_history" do
    assert_difference('StockHistory.count') do
      post :create, stock_history: { alteration: @stock_history.alteration, description: @stock_history.description, stock_id: @stock_history.stock_id }
    end

    assert_redirected_to stock_history_path(assigns(:stock_history))
  end

  test "should show stock_history" do
    get :show, id: @stock_history
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @stock_history
    assert_response :success
  end

  test "should update stock_history" do
    patch :update, id: @stock_history, stock_history: { alteration: @stock_history.alteration, description: @stock_history.description, stock_id: @stock_history.stock_id }
    assert_redirected_to stock_history_path(assigns(:stock_history))
  end

  test "should destroy stock_history" do
    assert_difference('StockHistory.count', -1) do
      delete :destroy, id: @stock_history
    end

    assert_redirected_to stock_histories_path
  end
end
