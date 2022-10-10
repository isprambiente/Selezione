# frozen_string_literal: true

require 'test_helper'

class User::RequestsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @user = create :user
    @user_request  = create :request, user: @user
    @other_request = create :request
  end

  test 'index require user signed in' do
    get user_requests_url(@user.id)
    assert_response :redirect
    assert_redirected_to new_user_session_url
  end

  test 'authenticated user should get index' do
    sign_in @user
    get user_requests_url(@user.id)
    assert_response :success
    assert_match @user_request.code, @response.body
  end

  test 'authenticated user should get only his request' do
    sign_in @user
    get user_requests_url(@other_request.user.id)
    assert_response :unauthorized
  end

  test 'authenticated user is required for create request' do
    assert_no_difference ['Request.count'] do
      post user_requests_url(@user.id), params: { request: { profile_id: create(:profile).id } }
    end
    assert_redirected_to new_user_session_url
  end

  test 'an user should create request' do
    sign_in @user
    assert_difference(['Request.count']) do
      post user_requests_url(@user.id), params: { request: { profile_id: create(:profile).id } }
    end

    assert_redirected_to user_request_url(@user.id, Request.last, locale: :it)
    assert_equal Request.last.user, @user
  end

  test 'show request require user signed in' do
    get user_request_url @user, @user_request
    assert_redirected_to new_user_session_url
  end

  test 'authenticated user can show self request' do
    sign_in @user
    get user_request_url(@user, @user_request)
    assert_response :success
  end

  test 'an user cant show other user request' do
    sign_in @user
    get user_request_url @user, @other_request
    assert_response :not_found
    get user_request_url @other_request.user, @other_request
    assert_response :unauthorized
  end

  test 'edit request require user signed in' do
    get edit_user_request_url @user, @user_request
    assert_redirected_to new_user_session_url
  end

  test 'authenticated user can edit self request' do
    sign_in @user
    get edit_user_request_url @user, @user_request
    assert_response :success
  end

  test 'an user cant edit other user request' do
    sign_in @user
    get edit_user_request_url @other_request.user, @other_request
    assert_response :unauthorized
  end

  test 'update request require user signed in' do
    patch user_request_url(@user, @user_request), params: { request: { confirm: '1' } }
    get user_request_url @user, @user_request
    assert_redirected_to new_user_session_url
  end

  test 'authenticated user can update self request' do
    sign_in @user
    patch user_request_url(@user, @user_request), params: { request: { confirm: '1' } }
    assert_response :redirect
    assert_equal 'sended', Request.find(@user_request.id).status
    assert_redirected_to user_request_url(@user, @user_request, locale: :it)
  end

  test 'an user cant update other user request' do
    sign_in @user
    patch user_request_url(@other_request.user, @other_request), params: { request: { confirm: '1' } }
    assert_response :unauthorized
  end
end
