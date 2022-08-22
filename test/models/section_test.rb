# frozen_string_literal: true

require 'test_helper'

class SectionTest < ActiveSupport::TestCase
  test 'valid from factory' do
    section = build :section
    assert section.valid?
    assert section.save
  end

  # relations
  test 'belongs to profile' do
    section = create :section
    assert_equal 'Profile', section.profile.class.name
  end

  test 'has many questions' do
    section = create :section
    assert_equal 'ActiveRecord::Associations::CollectionProxy', section.questions.class.name
    assert_equal 'Question', section.questions.new.class.name
  end

  # Validations
  test 'profile is required' do
    profile = create :profile
    section = build :section, profile: nil
    assert_not section.valid?
    section.profile = profile
    assert section.valid?
    assert section.save
  end

  test 'title is required' do
    section = build :section, title: nil
    assert_not section.valid?
    section.title = 'ok'
    assert section.valid?
    assert section.save
  end

  test 'default scope' do
    profile = create :profile
    s1 = create :section, profile: profile, weight: 1
    s2 = create :section, profile: profile, weight: 0
    assert_equal profile.sections.first, s1
    assert_equal profile.sections.last, s2
  end

  # action_text field
  test 'top is action_text' do
    section = create :section
    assert_equal section.top.class.to_s, 'ActionText::RichText'
  end

  test 'bottom is action_text' do
    section = create :section
    assert_equal section.bottom.class.to_s, 'ActionText::RichText'
  end
end
