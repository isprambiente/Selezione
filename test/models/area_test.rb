# frozen_string_literal: true

require 'test_helper'

class AreaTest < ActiveSupport::TestCase
  test 'valid from factory' do
    area = build :area
    assert area.valid?
    assert area.save
  end

  # relations
  test 'belongs to contest' do
    area = create :area
    assert_equal 'Contest', area.contest.class.name
  end

  test 'has many profiles' do
    area = create :area
    assert_equal 'ActiveRecord::Associations::CollectionProxy', area.profiles.class.name
    assert_equal 'Profile', area.profiles.new.class.name
  end

  # Validations
  test 'contest is required' do
    contest = create :contest
    area = build :area, contest: nil
    assert_not area.valid?
    area.contest = contest
    assert area.valid?
    assert area.save
  end

  test 'title is required' do
    area = build :area, title: nil
    assert_not area.valid?
    area.title = 'ok'
    assert area.valid?
    assert area.save
  end

  test 'profiles_max_choice is required' do
    area = build :area, profiles_max_choice: nil
    assert_not area.valid?
    area.profiles_max_choice = 1
    assert area.valid?
    assert area.save
  end

  test 'profiles_max_choice must be integer' do
    area = build :area, profiles_max_choice: 1.5
    assert_not area.valid?
    area.profiles_max_choice = 2
    assert area.valid?
    assert area.save
  end

  # scope
  test 'default scope' do
    b = create :area, title: 'b'
    a = create :area, title: 'a'
    assert_equal 2, Area.all.count
    assert_equal a, Area.all.first
    assert_equal b, Area.all.last
  end
end
