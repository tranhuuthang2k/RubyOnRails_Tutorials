# frozen_string_literal: true

require 'test_helper'

class ProductDetailsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get product_details_index_url
    assert_response :success
  end
end
