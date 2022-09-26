require "test_helper"

class User::CareersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_career = user_careers(:one)
  end

  test "should get index" do
    get user_careers_url
    assert_response :success
  end

  test "should get new" do
    get new_user_career_url
    assert_response :success
  end

  test "should create user_career" do
    assert_difference("User::Career.count") do
      post user_careers_url, params: { user_career: { category: @user_career.category, description: @user_career.description, employer: @user_career.employer, start_at: @user_career.start_at, stop_at: @user_career.stop_at } }
    end

    assert_redirected_to user_career_url(User::Career.last)
  end

  test "should show user_career" do
    get user_career_url(@user_career)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_career_url(@user_career)
    assert_response :success
  end

  test "should update user_career" do
    patch user_career_url(@user_career), params: { user_career: { category: @user_career.category, description: @user_career.description, employer: @user_career.employer, start_at: @user_career.start_at, stop_at: @user_career.stop_at } }
    assert_redirected_to user_career_url(@user_career)
  end

  test "should destroy user_career" do
    assert_difference("User::Career.count", -1) do
      delete user_career_url(@user_career)
    end

    assert_redirected_to user_careers_url
  end
end
