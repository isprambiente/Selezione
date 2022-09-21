require "test_helper"

class AdditionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @addition = additions(:one)
  end

  test "should get index" do
    get additions_url
    assert_response :success
  end

  test "should get new" do
    get new_addition_url
    assert_response :success
  end

  test "should create addition" do
    assert_difference("Addition.count") do
      post additions_url, params: { addition: { description: @addition.description, url: @addition.url } }
    end

    assert_redirected_to addition_url(Addition.last)
  end

  test "should show addition" do
    get addition_url(@addition)
    assert_response :success
  end

  test "should get edit" do
    get edit_addition_url(@addition)
    assert_response :success
  end

  test "should update addition" do
    patch addition_url(@addition), params: { addition: { description: @addition.description, url: @addition.url } }
    assert_redirected_to addition_url(@addition)
  end

  test "should destroy addition" do
    assert_difference("Addition.count", -1) do
      delete addition_url(@addition)
    end

    assert_redirected_to additions_url
  end
end
