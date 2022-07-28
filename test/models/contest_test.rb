# frozen_string_literal: true

require 'test_helper'

class ContestTest < ActiveSupport::TestCase
  test 'valid from factory' do
    contest = build :contest
    assert contest.valid?
    assert contest.save
  end

  # relations
  test 'has many area' do
    contest = create :contest
    area = create :area, contest: contest
    assert_equal contest.areas.first, area
  end
  
  test 'area counter cache' do
    contest = create :contest
    a1 = create :area, contest: contest
    a2 = create :area, contest: contest
    assert_equal 2, contest.reload.areas_count
    a2.destroy
    assert_equal 1, contest.reload.areas_count
  end

  test 'body is an ActionText' do
    contest = build :contest
    assert_equal contest.body.class.name, 'ActionText::RichText'
  end

  # validations
  test 'code is required' do
    contest = build :contest, code: nil
    assert_not contest.valid?
    contest.code = 'qualcosa'
    assert contest.valid?
  end

  test 'title is required' do
    contest = build :contest, title: nil
    assert_not contest.valid?
    contest.title = 'qualcosa'
    assert contest.valid?
  end

  test 'start_at is required' do
    contest = build :contest, start_at: nil
    assert_not contest.valid?
    contest.start_at = Time.zone.now
    assert contest.valid?
  end

  test 'stop_at is required' do
    contest = build :contest, stop_at: nil
    assert_not contest.valid?
    contest.stop_at = Time.zone.now
    assert contest.valid?
  end

  test 'areas_max_choice is required' do
    contest = build :contest, areas_max_choice: nil
    assert_not contest.valid?
    contest.areas_max_choice = 1
    assert contest.valid?
  end
  
  test 'areas_max_choice it must be integer' do
    contest = build :contest, areas_max_choice: 1.5
    assert_not contest.valid?
    contest.areas_max_choice = 1
    assert contest.valid?
  end

  # scope
  test 'default scope' do
    c1 = create :contest_ended
    c2 = create :contest_future
    c3 = create :contest
    assert_equal c2, Contest.all.first
    assert_equal c1, Contest.all.last
  end

  test 'scope future' do
    c1 = create :contest_ended
    c2 = create :contest_future
    c3 = create :contest
    assert_equal 1, Contest.future.count
    assert_equal c2, Contest.future.first
  end

  test 'scope active' do
    c1 = create :contest_ended
    c2 = create :contest_future
    c3 = create :contest
    assert_equal 1, Contest.active.count
    assert_equal c3, Contest.active.first
  end

  test 'scope ended' do
    c1 = create :contest_ended
    c2 = create :contest_future
    c3 = create :contest
    assert_equal 1, Contest.ended.count
    assert_equal c1, Contest.ended.first
  end
  test 'scope published`' do
    c1 = create :contest_ended
    c2 = create :contest_future
    c3 = create :contest
    assert_equal 2, Contest.published.count
    assert_equal c3, Contest.published.first
    assert_equal c1, Contest.published.last
  end

  #method
  test 'active?' do
    c1 = create :contest_ended
    c2 = create :contest_future
    c3 = create :contest
    assert_not c1.active?
    assert_not c2.active?
    assert c3.active?
  end

end
