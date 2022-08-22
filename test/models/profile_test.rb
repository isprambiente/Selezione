# frozen_string_literal: true

require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  test 'valid from factory' do
    profile = build :profile
    assert profile.valid?
    assert profile.save
  end

  # relations
  test 'belongs to area' do
    profile = create :profile
    assert_equal 'Area', profile.area.class.name
  end

  test 'has many sections' do
    profile = create :profile
    assert_equal 'ActiveRecord::Associations::CollectionProxy', profile.sections.class.name
    assert_equal 'Section', profile.sections.new.class.name
  end

  # Validations
  test 'title is required' do
    profile = build :profile, title: nil
    assert_not profile.valid?
    profile.title = 'ok'
    assert profile.valid?
    assert profile.save
  end
end
