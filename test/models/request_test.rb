# frozen_string_literal: true

require 'test_helper'

class RequestTest < ActiveSupport::TestCase
  test 'valid from factory' do
    request = build :request
    assert request.valid?
    assert request.save
  end

  # relations
  test 'belongs to profile' do
    request = create :request
    assert_equal 'Profile', request.profile.class.name
  end

  test 'belongs to user' do
    request = create :request
    assert_equal 'User', request.user.class.name
  end

  test 'has many answers' do
    request = create :request
    assert_equal 'ActiveRecord::Associations::CollectionProxy', request.answers.class.name
    assert_equal 'Answer', request.answers.new.class.name
  end

  # Validations
  test 'presence of profile' do
    request = build :request, profile: nil
    assert_not request.valid?
    request.profile = create :profile
    assert request.valid?
    assert request.save
  end

  test 'presence of user' do
    request = build :request, user: nil
    assert_not request.valid?
    request.user = create :user
    assert request.valid?
    assert request.save
  end

  test 'presence of status' do
    request = build :request, status: nil
    assert_not request.valid?
    request.status = 'editing'
    assert request.valid?
    assert request.save
  end

  test 'active? must be true if status_editing?' do
    request = create :request
    assert_equal request.active?, true
    assert request.valid?
    request.profile.area.contest.update start_at: Time.now - 1.days, stop_at: Time.now - 2.days
    assert_equal request.active?, false
    assert_not request.valid?
  end

  test 'active must be true if status_sended?' do
    request = create :request, status: 'sended'
    assert_equal request.active?, true
    assert request.valid?
    request.profile.area.contest.update start_at: Time.now - 1.days, stop_at: Time.now - 2.days
    assert_equal request.active?, false
    assert_not request.valid?
  end

  test 'active must be true if status_editing?' do
    request = create :request, status: 'sended'
    assert request.active?
    assert request.valid?
    request.profile.area.contest.update start_at: Time.now - 1.days, stop_at: Time.now - 2.days
    assert_not request.active?
    assert_not request.valid?
  end

  test 'ended must be true if status_rejected?' do
    request = create :request, status: 'sended'
    request.status = 'rejected'
    assert_not request.ended?
    assert_not request.valid?
    request.profile.area.contest.update start_at: Time.now - 1.days, stop_at: Time.now - 2.days
    assert request.ended?
    assert request.valid?
  end

  test 'ended must be true if status_accepted?' do
    request = create :request, status: 'sended'
    request.status = 'accepted'
    assert_not request.ended?
    assert_not request.valid?
    request.profile.area.contest.update start_at: Time.now - 1.days, stop_at: Time.now - 2.days
    assert request.ended?
    assert request.valid?
  end

  test 'ended must be true if status_valutated?' do
    request = create :request, status: 'sended'
    request.status = 'valutated'
    assert_not request.ended?
    assert_not request.valid?
    request.profile.area.contest.update start_at: Time.now - 1.days, stop_at: Time.now - 2.days
    assert request.ended?
    assert request.valid?
  end

  test 'answer_required must be an empty list if status_sended?' do
    request = create :request
    section = create :section, profile: request.profile
    question1 = create :question, section: section, mandatory: true
    question2 = create :question, section: section, mandatory: false
    request.status = 'sended'
    assert_not request.valid?
    request.answers.create request: request, question: question1, value: 'value'
    assert request.valid?
    request.answers.create request: request, question: question2, value: 'value'
    assert request.valid?
    request.answers.where(question: question1).each(&:destroy)
    assert_not request.valid?
  end
end
