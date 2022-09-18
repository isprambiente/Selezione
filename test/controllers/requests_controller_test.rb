# frozen_string_literal: true

require 'test_helper'

class RequestsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @user    = create :user
    @user_request  = create :request, user: @user
    @other_request = create :request
  end

  test 'index require user signed in' do
    get requests_url
    assert_response :redirect
  end

  test 'authenticated user should get index' do
    sign_in @user
    get requests_url
    assert_response :success
  end

  test 'authenticated user should get only his request' do
    sign_in @user
    get requests_url
    assert_match @user_request.code, @response.body
    assert_no_match @other_request.code, @response.body
  end

  test 'authenticated user is required for create request' do
    assert_no_difference ['Request.count'] do
      post requests_url, params: { request: { profile_id: create(:profile).id }}
      end
    assert_redirected_to new_user_session_url
  end

  test 'an user should create request' do
    sign_in @user
    assert_difference(['Request.count']) do
      post requests_url, params: { request: { profile_id: create(:profile).id } }
    end

    assert_redirected_to request_url(Request.last, locale: :it)
    assert_equal Request.last.user, @user 
  end

  test 'show request require user signed in' do
    get request_url @user_request
    assert_redirected_to new_user_session_url()
  end

  test 'authenticated user can show self request' do
    sign_in @user
    get request_url @user_request
    assert_response :success
  end

  test 'an user cant show other user request' do
    sign_in @user
    get request_url @other_request
    assert_response :unauthorized
  end

  test 'edit request require user signed in' do
    get edit_request_url @user_request
    assert_redirected_to new_user_session_url()
  end

  test 'authenticated user can edit self request' do
    sign_in @user
    get edit_request_url @user_request
    assert_response :success
  end

  test 'an user cant edit other user request' do
    sign_in @user
    get edit_request_url @other_request
    assert_response :unauthorized
  end


  test 'update request require user signed in' do
    get request_url @user_request
    assert_redirected_to new_user_session_url()
  end

  test 'authenticated user can update self request' do
    sign_in @user
    patch request_url(@user_request), params: { request: { confirm: '1' } }
    assert_response :redirect
    assert_equal 'sended', Request.find(@user_request.id).status
    assert_redirected_to request_url(@user_request, locale: :it)
  end

  test 'an user cant update other user request' do
    sign_in @user
    patch request_url(@other_request), params: { request: { confirm: '1' } }
    assert_response :unauthorized
  end

end
