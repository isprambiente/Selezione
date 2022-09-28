require "test_helper"

class User::SectionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @user_request   = create :request
    @user_section   = create :section, profile: @user_request.profile
    @user           = @user_request.user
    @other_request  = create :request
    @other_section  = create :section, profile: @other_request.profile
    @other_user     = @other_request.user
  end

  test 'unauthenticated cant get show' do
    get user_request_section_url(@user, @user_request, @user_section)
    assert_response :redirect
    assert_redirected_to new_user_session_url
  end

  test 'user should get show' do
    sign_in @user
    get user_request_section_url(@user, @user_request, @user_section)
    assert_response :success
  end

  test 'user cant get other show' do
    sign_in @user
    get user_request_section_url(@user, @user_request, @other_section)
    assert_response :not_found
    get user_request_section_url(@other_user, @other_request, @other_section)
    assert_response :unauthorized
  end
end
