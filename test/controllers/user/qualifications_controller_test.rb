# frozen_string_literal: true

require 'test_helper'

class User::QualificationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @user_qualification = create :qualification
    @user_request   = @user_qualification.request
    @user           = @user_request.user
    @other_qualification = create :qualification
    @other_request  = @other_qualification.request
    @other_user     = @other_request.user
  end

  test 'unauthenticated cant get index' do
    get user_request_qualifications_url(@user, @user_request)
    assert_response :redirect
    assert_redirected_to new_user_session_url
  end

  test 'user should get index' do
    sign_in @user
    get user_request_qualifications_url(@user, @user_request)
    assert_response :success
    assert_match @user_qualification.title, @response.body
  end

  test 'user should get index if sended' do
    sign_in @user
    @user_request.update status: :sended, confirm: true
    get user_request_qualifications_url(@user, @user_request)
    assert_response :success
    assert_match @user_qualification.title, @response.body
  end

  test 'user should get index if ended' do
    sign_in @user
    @user_request.contest.update start_at: Time.zone.now - 2.days, stop_at: Time.zone.now - 1.day
    get user_request_qualifications_url(@user, @user_request)
    assert_response :success
    assert_match @user_qualification.title, @response.body
  end

  test 'user cant get other qualification index' do
    sign_in @user
    get user_request_qualifications_url(@user, @other_request)
    assert_response :not_found
    get user_request_qualifications_url(@other_user, @other_request)
    assert_response :unauthorized
    get user_request_qualifications_url(@other_user, @user_request)
    assert_response :unauthorized
  end

  test 'unauthenticated cant get new' do
    get new_user_request_qualification_url(@user, @user_request)
    assert_response :redirect
    assert_redirected_to new_user_session_url
  end

  test 'user should get new' do
    sign_in @user
    get new_user_request_qualification_url(@user, @user_request)
    assert_response :success
  end

  test 'user cant get new if sended' do
    sign_in @user
    @user_request.update status: :sended, confirm: true
    get new_user_request_qualification_url(@user, @user_request)
    assert_response :unauthorized
  end

  test 'user cant get new if ended' do
    sign_in @user
    @user_request.contest.update start_at: Time.zone.now - 2.days, stop_at: Time.zone.now - 1.day
    get new_user_request_qualification_url(@user, @user_request)
    assert_response :unauthorized
  end

  test 'user cant get other new' do
    sign_in @user
    get new_user_request_qualification_url(@user, @other_request)
    assert_response :not_found
    get new_user_request_qualification_url(@other_user, @other_request)
    assert_response :unauthorized
    get new_user_request_qualification_url(@other_user, @user_request)
    assert_response :unauthorized
  end

  test 'unauthenticated cant get create qualification' do
    assert_no_difference('Qualification.count') do
      post user_request_qualifications_url(@user, @user_request), params: { qualification: { title: 'New qualification' } }
    end
    assert_response :redirect
    assert_redirected_to new_user_session_url
  end

  test 'user should create qualification' do
    sign_in @user
    assert_difference('Qualification.count') do
      post user_request_qualifications_url(@user, @user_request), params: { qualification: attributes_for(:qualification) }
    end

    assert_redirected_to user_request_qualifications_url(@user, @user_request, locale: :it)
  end

  test 'user cant create qualification if sended' do
    sign_in @user
    @user_request.update status: :sended, confirm: true
    assert_no_difference('Qualification.count') do
      post user_request_qualifications_url(@user, @user_request), params: { qualification: { title: 'New qualification' } }
    end

    assert_response :unauthorized
  end

  test 'user cant create qualification if ended' do
    sign_in @user
    @user_request.contest.update start_at: Time.zone.now - 2.days, stop_at: Time.zone.now - 1.day
    assert_no_difference('Qualification.count') do
      post user_request_qualifications_url(@user, @user_request), params: { qualification: { title: 'New qualification' } }
    end

    assert_response :unauthorized
  end

  test 'user cant create other qualification' do
    sign_in @user
    assert_no_difference('Qualification.count') do
      post user_request_qualifications_url(@user, @other_request), params: { qualification: { title: 'New qualification' } }
    end
    assert_response :not_found
    assert_no_difference('Qualification.count') do
      post user_request_qualifications_url(@other_user, @other_request), params: { qualification: { title: 'New qualification' } }
    end
    assert_response :unauthorized
    assert_no_difference('Qualification.count') do
      post user_request_qualifications_url(@other_user, @user_request), params: { qualification: { title: 'New qualification' } }
    end
    assert_response :unauthorized
  end

  test 'unauthenticated cant get show' do
    get user_request_qualification_url(@user, @user_request, @user_qualification)
    assert_response :redirect
    assert_redirected_to new_user_session_url
  end

  test 'user should get show' do
    sign_in @user
    get user_request_qualification_url(@user, @user_request, @user_qualification)
    assert_response :success
  end

  test 'user cant get other show' do
    sign_in @user
    get user_request_qualification_url(@user, @user_request, @other_qualification)
    assert_response :not_found
    get user_request_qualification_url(@other_user, @other_request, @other_qualification)
    assert_response :unauthorized
  end

  test 'unauthenticated cant get edit' do
    get edit_user_request_qualification_url(@user, @user_request, @user_qualification)
    assert_response :redirect
    assert_redirected_to new_user_session_url
  end

  test 'user should get edit' do
    sign_in @user
    get edit_user_request_qualification_url(@user, @user_request, @user_qualification)
    assert_response :success
  end

  test 'user cant get edit if sended' do
    sign_in @user
    @user_request.update status: :sended, confirm: true
    get edit_user_request_qualification_url(@user, @user_request, @user_qualification)
    assert_response :unauthorized
  end

  test 'user cant get edit if ended' do
    sign_in @user
    @user_request.contest.update start_at: Time.zone.now - 2.days, stop_at: Time.zone.now - 1.day
    get edit_user_request_qualification_url(@user, @user_request, @user_qualification)
    assert_response :unauthorized
  end

  test 'user cant get other edit' do
    sign_in @user
    get edit_user_request_qualification_url(@user, @user_request, @other_qualification)
    assert_response :not_found
    get edit_user_request_qualification_url(@other_user, @other_request, @other_qualification)
    assert_response :unauthorized
  end

  test 'unauthenticated cant get update qualification' do
    patch user_request_qualification_url(@user, @user_request, @user_qualification), params: { qualification: { title: 'updated' } }
    assert_response :redirect
    assert_redirected_to new_user_session_url
  end

  test 'user should update qualification' do
    sign_in @user
    patch user_request_qualification_url(@user, @user_request, @user_qualification), params: { qualification: { title: 'updated' } }
    assert_redirected_to user_request_qualification_url(@user, @user_request, @user_qualification, locale: :it)
    assert_equal 'updated', Qualification.find(@user_qualification.id).title
  end

  test 'user cant update qualification if sended' do
    sign_in @user
    @user_request.update status: :sended, confirm: true
    patch user_request_qualification_url(@user, @user_request, @user_qualification), params: { qualification: { title: 'updated' } }
    assert_response :unauthorized
    assert_equal @user_qualification.title, Qualification.find(@user_qualification.id).title
  end

  test 'user cand update qualification if ended' do
    sign_in @user
    @user_request.contest.update start_at: Time.zone.now - 2.days, stop_at: Time.zone.now - 1.day
    patch user_request_qualification_url(@user, @user_request, @user_qualification), params: { qualification: { title: 'updated' } }
    assert_response :unauthorized
    assert_equal @user_qualification.title, Qualification.find(@user_qualification.id).title
  end

  test 'user cant update other qualification' do
    sign_in @user
    patch user_request_qualification_url(@user, @user_request, @other_qualification), params: { qualification: { title: 'updated' } }
    assert_response :not_found
    assert_equal @other_qualification.title, Qualification.find(@other_qualification.id).title
    patch user_request_qualification_url(@other_user, @other_request, @other_qualification), params: { qualification: { title: 'updated' } }
    assert_response :unauthorized
    assert_equal @other_qualification.title, Qualification.find(@other_qualification.id).title
    patch user_request_qualification_url(@other_user, @other_request, @user_qualification), params: { qualification: { title: 'updated' } }
    assert_response :unauthorized
    assert_equal @user_qualification.title, Qualification.find(@user_qualification.id).title
  end

  test 'unauthenticated cant get destroy qualification' do
    assert_no_difference('Qualification.count') do
      delete user_request_qualification_url(@user, @user_request, @user_qualification)
    end
    assert_response :redirect
    assert_redirected_to new_user_session_url
  end

  test 'user should destroy qualification' do
    sign_in @user
    assert_difference('Qualification.count', -1) do
      delete user_request_qualification_url(@user, @user_request, @user_qualification)
    end

    assert_redirected_to user_request_qualifications_url(@user, @user_request, locale: :it)
  end

  test 'user cant destroy qualification is sended' do
    sign_in @user
    @user_request.update status: :sended, confirm: true
    assert_no_difference('Qualification.count') do
      delete user_request_qualification_url(@user, @user_request, @user_qualification)
    end

    assert_response :unauthorized
  end

  test 'user cant destroy qualification is ended' do
    sign_in @user
    @user_request.contest.update start_at: Time.zone.now - 2.days, stop_at: Time.zone.now - 1.day
    assert_no_difference('Qualification.count') do
      delete user_request_qualification_url(@user, @user_request, @user_qualification)
    end

    assert_response :unauthorized
  end

  test 'user cant destroy other qualification' do
    sign_in @user
    assert_no_difference('Qualification.count') do
      delete user_request_qualification_url(@user, @user_request, @other_qualification)
    end
    assert_response :not_found
    assert_no_difference('Qualification.count') do
      delete user_request_qualification_url(@other_user, @other_request, @other_qualification)
    end
    assert_response :unauthorized
    assert_no_difference('Qualification.count') do
      delete user_request_qualification_url(@other_user, @user_request, @user_qualification)
    end
    assert_response :unauthorized
  end
end
