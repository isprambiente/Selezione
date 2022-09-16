# frozen_string_literal: true

require 'test_helper'

class ContestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contest = create :contest
    @contest_future = create :contest_future
    @contest_ended = create :contest_ended
  end

  test 'should get index with active contests' do
    get contests_url
    assert_response :success

    assert_equal 'index', @controller.action_name
    assert_match @contest.title, @response.body
    assert_no_match @contest_ended.title, @response.body
    assert_no_match @contest_future.title, @response.body
  end

  test 'should get index with ended contests with type ended' do
    get contests_url, params: { filter: { type: 'ended' } }
    assert_response :success

    assert_equal 'index', @controller.action_name
    assert_match @contest_ended.title, @response.body
    assert_no_match @contest.title, @response.body
    assert_no_match @contest_future.title, @response.body
  end

  test 'should get index filered by text with params text' do
    get contests_url, params: { filter: { text: @contest.title } }
    assert_response :success

    assert_equal 'index', @controller.action_name
    assert_match @contest.title, @response.body
    assert_no_match @contest_ended.title, @response.body
    assert_no_match @contest_future.title, @response.body
  end

  test 'should show contest active' do
    get contest_url(@contest)
    assert_response :success
    assert_equal 'show', @controller.action_name
    assert_match @contest.title, @response.body
  end

  test 'should show contest ended' do
    get contest_url(@contest_ended)
    assert_response :success
    assert_equal 'show', @controller.action_name
    assert_match @contest_ended.title, @response.body
  end

  test 'should not show contest future' do
    get contest_url(@contest_future)
    assert_response :not_found
  end
end
