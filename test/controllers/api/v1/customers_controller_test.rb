require "test_helper"

class Api::V1::CustomersControllerTest < ActionDispatch::IntegrationTest
  test "should get nearest_customers" do
    get api_v1_customers_nearest_customers_url
    assert_response :success
  end
end
