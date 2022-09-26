require "test_helper"

class User::CareersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @user_career  = create :career
    @user_request   = @user_career.request
    @user           = @user_request.user
    @other_career = create :career
    @other_request  = @other_career.request
    @other_user     = @other_request.user
  end

  test "unauthenticated cant get index" do
    get user_request_careers_url(@user, @user_request)
    assert_response :redirect
    assert_redirected_to new_user_session_url()
  end

  test "user should get index" do
    sign_in @user
    get user_request_careers_url(@user, @user_request)
    assert_response :success
    assert_match @user_career.employer, @response.body
  end

  test "user should get index if sended" do
    sign_in @user
    @user_request.update status: :sended, confirm: true
    get user_request_careers_url(@user, @user_request)
    assert_response :success
    assert_match @user_career.employer, @response.body
  end

  test "user should get index if ended" do
    sign_in @user
    @user_request.contest.update start_at: Time.now - 2.day, stop_at: Time.now - 1.day
    get user_request_careers_url(@user, @user_request)
    assert_response :success
    assert_match @user_career.employer, @response.body
  end

  test "user cant get other career index" do
    sign_in @user
    get user_request_careers_url(@user, @other_request)
    assert_response :not_found
    get user_request_careers_url(@other_user, @other_request)
    assert_response :unauthorized
    get user_request_careers_url(@other_user, @user_request)
    assert_response :unauthorized
  end

  test "unauthenticated cant get new" do
    get new_user_request_career_url(@user, @user_request)
    assert_response :redirect
    assert_redirected_to new_user_session_url()
  end

  test "user should get new" do
    sign_in @user
    get new_user_request_career_url(@user, @user_request)
    assert_response :success
  end

  test "user cant get new if sended" do
    sign_in @user
    @user_request.update status: :sended, confirm: true
    get new_user_request_career_url(@user, @user_request)
    assert_response :unauthorized
  end

  test "user cant get new if ended" do
    sign_in @user
    @user_request.contest.update start_at: Time.now - 2.day, stop_at: Time.now - 1.day
    get new_user_request_career_url(@user, @user_request)
    assert_response :unauthorized
  end

  test "user cant get other new" do
    sign_in @user 
    get new_user_request_career_url(@user, @other_request)
    assert_response :not_found
    get new_user_request_career_url(@other_user, @other_request)
    assert_response :unauthorized
    get new_user_request_career_url(@other_user, @user_request)
    assert_response :unauthorized
  end

  test "unauthenticated cant get create career" do
    assert_no_difference("Career.count") do
      post user_request_careers_url(@user, @user_request), params: { career: { employer: 'New career' } }
    end
    assert_response :redirect
    assert_redirected_to new_user_session_url()
  end

  test "user should create career" do
    sign_in @user
    assert_difference("Career.count") do
      post user_request_careers_url(@user, @user_request), params: { career: attributes_for(:career) }
    end

    assert_redirected_to user_request_careers_url(@user, @user_request, locale: :it)
  end

  test "user cant create career if sended" do
    sign_in @user
    @user_request.update status: :sended, confirm: true
    assert_no_difference("Career.count") do
      post user_request_careers_url(@user, @user_request), params: { career: { employer: 'New career' } }
    end

    assert_response :unauthorized
  end

  test "user cant create career if ended" do
    sign_in @user
    @user_request.contest.update start_at: Time.now - 2.day, stop_at: Time.now - 1.day
    assert_no_difference("Career.count") do
      post user_request_careers_url(@user, @user_request), params: { career: { employer: 'New career' } }
    end

    assert_response :unauthorized
  end

  test "user cant create other career" do
    sign_in @user
    assert_no_difference("Career.count") do
      post user_request_careers_url(@user, @other_request), params: { career: { employer: 'New career' } }
    end
    assert_response :not_found
    assert_no_difference("Career.count") do
      post user_request_careers_url(@other_user, @other_request), params: { career: { employer: 'New career' } }
    end
    assert_response :unauthorized
    assert_no_difference("Career.count") do
      post user_request_careers_url(@other_user, @user_request), params: { career: { employer: 'New career' } }
    end
    assert_response :unauthorized
  end

  test "unauthenticated cant get show" do
    get user_request_career_url(@user, @user_request, @user_career)
    assert_response :redirect
    assert_redirected_to new_user_session_url()
  end

  test "user should get show" do
    sign_in @user
    get user_request_career_url(@user, @user_request, @user_career)
    assert_response :success
  end

  test "user cant get other show" do
    sign_in @user
    get user_request_career_url(@user, @user_request, @other_career)
    assert_response :not_found
    get user_request_career_url(@other_user, @other_request, @other_career)
    assert_response :unauthorized
  end

  test "unauthenticated cant get edit" do
    get edit_user_request_career_url(@user, @user_request, @user_career)
    assert_response :redirect
    assert_redirected_to new_user_session_url()
  end

  test "user should get edit" do
    sign_in @user
    get edit_user_request_career_url(@user, @user_request, @user_career)
    assert_response :success
  end

  test "user cant get edit if sended" do
    sign_in @user
    @user_request.update status: :sended, confirm: true
    get edit_user_request_career_url(@user, @user_request, @user_career)
    assert_response :unauthorized
  end
 
  test "user cant get edit if ended" do
    sign_in @user
    @user_request.contest.update start_at: Time.now - 2.day, stop_at: Time.now - 1.day
    get edit_user_request_career_url(@user, @user_request, @user_career)
    assert_response :unauthorized
  end
 
  test "user cant get other edit" do
    sign_in @user
    get edit_user_request_career_url(@user, @user_request, @other_career)
    assert_response :not_found
    get edit_user_request_career_url(@other_user, @other_request, @other_career)
    assert_response :unauthorized
  end
  
  test "unauthenticated cant get update career" do
    patch user_request_career_url(@user, @user_request, @user_career), params: { career: { employer: 'updated' } }
    assert_response :redirect
    assert_redirected_to new_user_session_url()
  end

  test "user should update career" do
    sign_in @user
    patch user_request_career_url(@user, @user_request, @user_career), params: { career: { employer: 'updated' } }
    assert_redirected_to user_request_career_url(@user, @user_request, @user_career, locale: :it)
    assert_equal 'updated', Career.find(@user_career.id).employer
  end

  test "user cant update career if sended" do
    sign_in @user
    @user_request.update status: :sended, confirm: true
    patch user_request_career_url(@user, @user_request, @user_career), params: { career: { employer: 'updated' } }
    assert_response :unauthorized
    assert_equal @user_career.employer, Career.find(@user_career.id).employer
  end

  test "user cand update career if ended" do
    sign_in @user
    @user_request.contest.update start_at: Time.now - 2.day, stop_at: Time.now - 1.day
    patch user_request_career_url(@user, @user_request, @user_career), params: { career: { employer: 'updated' } }
    assert_response :unauthorized
    assert_equal @user_career.employer, Career.find(@user_career.id).employer
  end

  test "user cant update other career" do
    sign_in @user
    patch user_request_career_url(@user, @user_request, @other_career), params: { career: { employer: 'updated' } }
    assert_response :not_found
    assert_equal @other_career.employer, Career.find(@other_career.id).employer
    patch user_request_career_url(@other_user, @other_request, @other_career), params: { career: { employer: 'updated' } }
    assert_response :unauthorized
    assert_equal @other_career.employer, Career.find(@other_career.id).employer
    patch user_request_career_url(@other_user, @other_request, @user_career), params: { career: { employer: 'updated' } }
    assert_response :unauthorized
    assert_equal @user_career.employer, Career.find(@user_career.id).employer
  end

  test "unauthenticated cant get destroy career" do
    assert_no_difference("Career.count") do
      delete user_request_career_url(@user, @user_request, @user_career)
    end
    assert_response :redirect
    assert_redirected_to new_user_session_url()
  end

  test "user should destroy career" do
    sign_in @user
    assert_difference("Career.count", -1) do
      delete user_request_career_url(@user, @user_request, @user_career)
    end

    assert_redirected_to user_request_careers_url(@user, @user_request, locale: :it)
  end

  test "user cant destroy career is sended" do
    sign_in @user
    @user_request.update status: :sended, confirm: true
    assert_no_difference("Career.count") do
      delete user_request_career_url(@user, @user_request, @user_career)
    end

    assert_response :unauthorized
  end

  test "user cant destroy career is ended" do
    sign_in @user
    @user_request.contest.update start_at: Time.now - 2.day, stop_at: Time.now - 1.day
    assert_no_difference("Career.count") do
      delete user_request_career_url(@user, @user_request, @user_career)
    end

    assert_response :unauthorized
  end

  test "user cant destroy other career" do
    sign_in @user
    assert_no_difference("Career.count") do
      delete user_request_career_url(@user, @user_request, @other_career)
    end
    assert_response :not_found
    assert_no_difference("Career.count") do
      delete user_request_career_url(@other_user, @other_request, @other_career)
    end
    assert_response :unauthorized
    assert_no_difference("Career.count") do
      delete user_request_career_url(@other_user, @user_request, @user_career)
    end
    assert_response :unauthorized
  end
end
