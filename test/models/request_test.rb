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

  test 'has many qualifications' do
    request = create :request
    assert_equal 'ActiveRecord::Associations::CollectionProxy', request.qualifications.class.name
    assert_equal 'Qualification', request.qualifications.new.class.name
  end

  test 'has many additions' do
    request = create :request
    assert_equal 'ActiveRecord::Associations::CollectionProxy', request.additions.class.name
    assert_equal 'Addition', request.additions.new.class.name
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
    request.profile.area.contest.update start_at: Time.zone.now - 1.day, stop_at: Time.zone.now - 2.days
    assert_equal request.active?, false
    assert_not request.valid?
  end

  test 'active must be true if status_sended?' do
    request = create :request, status: 'sended'
    assert_equal request.active?, true
    assert request.valid?
    request.profile.area.contest.update start_at: Time.zone.now - 1.day, stop_at: Time.zone.now - 2.days
    assert_equal request.active?, false
    assert_not request.valid?
  end

  test 'active must be true if status_editing?' do
    request = create :request, status: 'sended'
    assert request.active?
    assert request.valid?
    request.profile.area.contest.update start_at: Time.zone.now - 1.day, stop_at: Time.zone.now - 2.days
    assert_not request.active?
    assert_not request.valid?
  end

  test 'ended must be true if status_rejected?' do
    request = create :request, status: 'sended'
    request.status = 'rejected'
    assert_not request.ended?
    assert_not request.valid?
    request.profile.area.contest.update start_at: Time.zone.now - 1.day, stop_at: Time.zone.now - 2.days
    assert request.ended?
    assert request.valid?
  end

  test 'ended must be true if status_accepted?' do
    request = create :request, status: 'sended'
    request.status = 'accepted'
    assert_not request.ended?
    assert_not request.valid?
    request.profile.area.contest.update start_at: Time.zone.now - 1.day, stop_at: Time.zone.now - 2.days
    assert request.ended?
    assert request.valid?
  end

  test 'ended must be true if status_valutated?' do
    request = create :request, status: 'sended'
    request.status = 'valutated'
    assert_not request.ended?
    assert_not request.valid?
    request.profile.area.contest.update start_at: Time.zone.now - 1.day, stop_at: Time.zone.now - 2.days
    assert request.ended?
    assert request.valid?
  end

  test 'answer_required? must be an empty list if status_sended?' do
    request = create :request
    section = create :section, profile: request.profile
    question1 = create :question, section: section, mandatory: true
    question2 = create :question, section: section, mandatory: false
    request.status = 'sended'
    assert_not request.valid?
    request.status = 'editing'
    request.answers.create request: request, question: question1, value: 'value'
    request.status = 'sended'
    assert request.valid?
    request.status = 'editing'
    request.answers.create request: request, question: question2, value: 'value'
    request.status = 'sended'
    assert request.valid?
    request.status = 'editing'
    request.answers.where(question: question1).each(&:destroy)
    request.status = 'sended'
    assert_not request.valid?
  end

  test 'other_user_area_requests get a list of the user requests in same area' do
    r1 = create :request, status: :sended
    r1.contest.update areas_max_choice: 2
    r1.area.update profiles_max_choice: 2
    r2 = create :request, profile: create(:profile, area: r1.area), user: r1.user, status: :sended
    r3 = create :request, profile: create(:profile, area: create(:area, contest: r1.contest)), user: r1.user, status: :sended
    assert r1.other_user_area_requests.exists?(id: r2.id)
    assert_not r1.other_user_area_requests.exists?(id: r3.id)
  end

  test 'profile_conflicts? must be false if status_sended?' do
    r1 = create :request, status: :sended
    assert_equal 1, r1.area.profiles_max_choice
    r2 = build :request, profile: create(:profile, area: r1.area), user: r1.user, status: :sended
    assert_not r2.valid?
    r1.update status: :editing
    assert r2.valid?
    assert r2.save
    assert_not r1.update status: :sended
  end

  test 'area_conflicts? must_be_false if status_sended?' do
    r1 = create :request, status: :sended
    assert_equal 1, r1.contest.areas_max_choice
    r2 = build :request, profile: create(:profile, area: create(:area, contest: r1.contest)), user: r1.user, status: :sended
    assert_not r2.valid?
    r1.update status: :editing
    assert r2.valid?
    assert r2.save
    assert_not r1.update status: :sended
  end

  test 'qualification_required must be true if status sended' do
    r = create :request
    r.status = :sended
    assert r.valid?
    r.profile.update qualifications_requested: %w[dsg lb]
    assert_not r.valid?
    r.status = :editing
    q = create :qualification, request: r, category: 'lvo'
    r.status = :sended
    assert_not r.valid?
    r.status = :editing
    q.update category: 'dsg'
    r.status = :sended
    assert r.valid?
    assert r.save
  end

  test 'careers.total_countable_months must be equal or greater than profile.careers_requested' do
    request = create :request, profile: create(:profile, careers_requested: 7)
    c1 = create :career, request: request
    assert_equal 6, request.careers.total_countable_months.round
    request.status = :sended
    assert_not request.valid?
    request.status = :editing
    create :career, request: request, start_on: c1.stop_on + 1.day, stop_on: c1.stop_on + 30.days
    assert_equal 7, request.careers.total_countable_months.round
    request.status = :sended
    assert request.valid?
    assert request.save
  end

  test 'confirm should be true on update if is active' do
    request = create :request, confirm: false
    assert_not request.valid?
    request.confirm = '1'
    assert request.valid?
    assert request.status_sended!
  end
end
