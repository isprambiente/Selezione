require "test_helper"

class AdditionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @user_addition  = create :addition
    @user_request   = @user_addition.request
    @user           = @user_request.user
    @other_addition = create :addition
    @other_request  = @other_addition.request
    @other_user     = @other_request.user
  end

  test "unauthenticated cant get index" do
    get user_request_additions_url(@user, @user_request)
    assert_response :redirect
    assert_redirected_to new_user_session_url()
  end

  test "user should get index" do
    sign_in @user
    get user_request_additions_url(@user, @user_request)
    assert_response :success
    assert_match @user_addition.title, @response.body
  end

  test "user should get index if sended" do
    sign_in @user
    @user_request.update status: :sended, confirm: true
    get user_request_additions_url(@user, @user_request)
    assert_response :success
    assert_match @user_addition.title, @response.body
  end

  test "user should get index if ended" do
    sign_in @user
    @user_request.contest.update start_at: Time.now - 2.day, stop_at: Time.now - 1.day
    get user_request_additions_url(@user, @user_request)
    assert_response :success
    assert_match @user_addition.title, @response.body
  end

  test "user cant get other addition index" do
    sign_in @user
    get user_request_additions_url(@user, @other_request)
    assert_response :not_found
    get user_request_additions_url(@other_user, @other_request)
    assert_response :unauthorized
    get user_request_additions_url(@other_user, @user_request)
    assert_response :unauthorized
  end

  test "unauthenticated cant get new" do
    get new_user_request_addition_url(@user, @user_request)
    assert_response :redirect
    assert_redirected_to new_user_session_url()
  end

  test "user should get new" do
    sign_in @user
    get new_user_request_addition_url(@user, @user_request)
    assert_response :success
  end

  test "user cant get new if sended" do
    sign_in @user
    @user_request.update status: :sended, confirm: true
    get new_user_request_addition_url(@user, @user_request)
    assert_response :unauthorized
  end

  test "user cant get new if ended" do
    sign_in @user
    @user_request.contest.update start_at: Time.now - 2.day, stop_at: Time.now - 1.day
    get new_user_request_addition_url(@user, @user_request)
    assert_response :unauthorized
  end

  test "user cant get other new" do
    sign_in @user 
    get new_user_request_addition_url(@user, @other_request)
    assert_response :not_found
    get new_user_request_addition_url(@other_user, @other_request)
    assert_response :unauthorized
    get new_user_request_addition_url(@other_user, @user_request)
    assert_response :unauthorized
  end

  test "unauthenticated cant get create addition" do
    assert_no_difference("Addition.count") do
      post user_request_additions_url(@user, @user_request), params: { addition: { title: 'New addition' } }
    end
    assert_response :redirect
    assert_redirected_to new_user_session_url()
  end

  test "user should create addition" do
    sign_in @user
    assert_difference("Addition.count") do
      post user_request_additions_url(@user, @user_request), params: { addition: { title: 'New addition' } }
    end

    assert_redirected_to user_request_additions_url(@user, @user_request, locale: :it)
  end

  test "user cant create addition if sended" do
    sign_in @user
    @user_request.update status: :sended, confirm: true
    assert_no_difference("Addition.count") do
      post user_request_additions_url(@user, @user_request), params: { addition: { title: 'New addition' } }
    end

    assert_response :unauthorized
  end

  test "user cant create addition if ended" do
    sign_in @user
    @user_request.contest.update start_at: Time.now - 2.day, stop_at: Time.now - 1.day
    assert_no_difference("Addition.count") do
      post user_request_additions_url(@user, @user_request), params: { addition: { title: 'New addition' } }
    end

    assert_response :unauthorized
  end

  test "user cant create other addition" do
    sign_in @user
    assert_no_difference("Addition.count") do
      post user_request_additions_url(@user, @other_request), params: { addition: { title: 'New addition' } }
    end
    assert_response :not_found
    assert_no_difference("Addition.count") do
      post user_request_additions_url(@other_user, @other_request), params: { addition: { title: 'New addition' } }
    end
    assert_response :unauthorized
    assert_no_difference("Addition.count") do
      post user_request_additions_url(@other_user, @user_request), params: { addition: { title: 'New addition' } }
    end
    assert_response :unauthorized
  end

  test "unauthenticated cant get show" do
    get user_request_addition_url(@user, @user_request, @user_addition)
    assert_response :redirect
    assert_redirected_to new_user_session_url()
  end

  test "user should get show" do
    sign_in @user
    get user_request_addition_url(@user, @user_request, @user_addition)
    assert_response :success
  end

  test "user cant get other show" do
    sign_in @user
    get user_request_addition_url(@user, @user_request, @other_addition)
    assert_response :not_found
    get user_request_addition_url(@other_user, @other_request, @other_addition)
    assert_response :unauthorized
  end

  test "unauthenticated cant get edit" do
    get edit_user_request_addition_url(@user, @user_request, @user_addition)
    assert_response :redirect
    assert_redirected_to new_user_session_url()
  end

  test "user should get edit" do
    sign_in @user
    get edit_user_request_addition_url(@user, @user_request, @user_addition)
    assert_response :success
  end

  test "user cant get edit if sended" do
    sign_in @user
    @user_request.update status: :sended, confirm: true
    get edit_user_request_addition_url(@user, @user_request, @user_addition)
    assert_response :unauthorized
  end
 
  test "user cant get edit if ended" do
    sign_in @user
    @user_request.contest.update start_at: Time.now - 2.day, stop_at: Time.now - 1.day
    get edit_user_request_addition_url(@user, @user_request, @user_addition)
    assert_response :unauthorized
  end
 
  test "user cant get other edit" do
    sign_in @user
    get edit_user_request_addition_url(@user, @user_request, @other_addition)
    assert_response :not_found
    get edit_user_request_addition_url(@other_user, @other_request, @other_addition)
    assert_response :unauthorized
  end
  
  test "unauthenticated cant get update addition" do
    patch user_request_addition_url(@user, @user_request, @user_addition), params: { addition: { title: 'updated' } }
    assert_response :redirect
    assert_redirected_to new_user_session_url()
  end

  test "user should update addition" do
    sign_in @user
    patch user_request_addition_url(@user, @user_request, @user_addition), params: { addition: { title: 'updated' } }
    assert_redirected_to user_request_addition_url(@user, @user_request, @user_addition, locale: :it)
    assert_equal 'updated', Addition.find(@user_addition.id).title
  end

  test "user cant update addition if sended" do
    sign_in @user
    @user_request.update status: :sended, confirm: true
    patch user_request_addition_url(@user, @user_request, @user_addition), params: { addition: { title: 'updated' } }
    assert_response :unauthorized
    assert_equal @user_addition.title, Addition.find(@user_addition.id).title
  end

  test "user cand update addition if ended" do
    sign_in @user
    @user_request.contest.update start_at: Time.now - 2.day, stop_at: Time.now - 1.day
    patch user_request_addition_url(@user, @user_request, @user_addition), params: { addition: { title: 'updated' } }
    assert_response :unauthorized
    assert_equal @user_addition.title, Addition.find(@user_addition.id).title
  end

  test "user cant update other addition" do
    sign_in @user
    patch user_request_addition_url(@user, @user_request, @other_addition), params: { addition: { title: 'updated' } }
    assert_response :not_found
    assert_equal @other_addition.title, Addition.find(@other_addition.id).title
    patch user_request_addition_url(@other_user, @other_request, @other_addition), params: { addition: { title: 'updated' } }
    assert_response :unauthorized
    assert_equal @other_addition.title, Addition.find(@other_addition.id).title
    patch user_request_addition_url(@other_user, @other_request, @user_addition), params: { addition: { title: 'updated' } }
    assert_response :unauthorized
    assert_equal @user_addition.title, Addition.find(@user_addition.id).title
  end

  test "unauthenticated cant get destroy addition" do
    assert_no_difference("Addition.count") do
      delete user_request_addition_url(@user, @user_request, @user_addition)
    end
    assert_response :redirect
    assert_redirected_to new_user_session_url()
  end

  test "user should destroy addition" do
    sign_in @user
    assert_difference("Addition.count", -1) do
      delete user_request_addition_url(@user, @user_request, @user_addition)
    end

    assert_redirected_to user_request_additions_url(@user, @user_request, locale: :it)
  end

  test "user cant destroy addition is sended" do
    sign_in @user
    @user_request.update status: :sended, confirm: true
    assert_no_difference("Addition.count") do
      delete user_request_addition_url(@user, @user_request, @user_addition)
    end

    assert_response :unauthorized
  end

  test "user cant destroy addition is ended" do
    sign_in @user
    @user_request.contest.update start_at: Time.now - 2.day, stop_at: Time.now - 1.day
    assert_no_difference("Addition.count") do
      delete user_request_addition_url(@user, @user_request, @user_addition)
    end

    assert_response :unauthorized
  end

  test "user cant destroy other addition" do
    sign_in @user
    assert_no_difference("Addition.count") do
      delete user_request_addition_url(@user, @user_request, @other_addition)
    end
    assert_response :not_found
    assert_no_difference("Addition.count") do
      delete user_request_addition_url(@other_user, @other_request, @other_addition)
    end
    assert_response :unauthorized
    assert_no_difference("Addition.count") do
      delete user_request_addition_url(@other_user, @user_request, @user_addition)
    end
    assert_response :unauthorized
  end
end

