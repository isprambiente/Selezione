# frozen_string_literal: true

require 'test_helper'

class User::AnswersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @user_request   = create :request
    @user_section   = create :section, profile: @user_request.profile
    @user_question  = create :question, section: @user_section
    @user           = @user_request.user
    @other_request  = create :request
    @other_section  = create :section, profile: @other_request.profile
    @other_question = create :question, section: @other_section
    @other_user     = @other_request.user
  end

  test 'unauthenticated cant update answer' do
    patch user_request_answer_url(@user, @user_request, @user_question), params: { answer: { value: 'updated' } }
    assert_response :redirect
    assert_redirected_to new_user_session_url
    assert_not Answer.find_by(request: @user_request, question: @user_question).present?
  end

  test 'user can update answer via http' do
    sign_in @user
    patch user_request_answer_url(@user, @user_request, @user_question, format: :turbo_stream), params: { answer: { value: 'updated' } }
    assert_response :success
    assert Answer.find_by(request: @user_request, question: @user_question).present?
  end

  test 'user cant update other answer' do
    sign_in @user
    patch user_request_answer_url(@user, @user_request, @other_question, format: :turbo_stream), params: { answer: { value: 'updated' } }
    assert_response :not_found
    assert_not Answer.find_by(request: @user_request, question: @other_question).present?
    patch user_request_answer_url(@other_user, @other_request, @other_question, format: :turbo_stream), params: { answer: { value: 'updated' } }
    assert_response :unauthorized
    assert_not Answer.find_by(request: @other_request, question: @other_question).present?
  end
end
