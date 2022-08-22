# frozen_string_literal: true

require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  test 'valid from factory' do
    question = build :question
    assert question.valid?
    assert question.save
  end

  # relations
  test 'belongs to section' do
    question = create :question
    assert_equal 'Section', question.section.class.name
  end

  test 'has many options' do
    question = create :question
    assert_equal 'ActiveRecord::Associations::CollectionProxy', question.options.class.name
    assert_equal 'Option', question.options.new.class.name
  end

  # validations
  test 'title is required' do
    question = build :question, title: nil
    assert_not question.valid?
    question.title = ''
    assert_not question.valid?
    question.title = 'ok'
    assert question.valid?
    assert question.save
  end

  test 'weight is required' do
    question = build :question, weight: nil
    assert_not question.valid?
    question.weight = ''
    assert_not question.valid?
    question.weight = 1
    assert question.valid?
    assert question.save
  end

  test 'category is required' do
    question = build :question, category: nil
    assert_not question.valid?
    question.category = ''
    assert_not question.valid?
    question.category = 'string'
    assert question.valid?
    assert question.save
  end

  test 'category is enum' do
    assert Question.defined_enums.key?('category')
  end

  # Scope
  test 'default scope is weight desc' do
    create :question, weight: 0
    create :question, weight: 10
    assert_equal Question.first.weight, 10
    assert_equal Question.last.weight, 0
  end

  # Methods
  test 'selectable?' do
    question = create :question, category: 'string'
    assert_not question.selectable?
    question.category = 'select'
    assert question.selectable?
    question.category = 'radio'
    assert question.selectable?
    question.category = 'multiselect'
    assert_not question.selectable?
  end

  test 'multiselectable?' do
    question = create :question, category: 'string'
    assert_not question.multiselectable?
    question.category = 'multiselect'
    assert question.multiselectable?
    question.category = 'checkbox'
    assert question.multiselectable?
    question.category = 'select'
    assert_not question.multiselectable?
  end

  test 'optionable?' do
    question = create :question, category: 'string'
    assert_not question.optionable?
    question.category = 'multiselect'
    assert question.optionable?
    question.category = 'checkbox'
    assert question.optionable?
    question.category = 'select'
    assert question.optionable?
    question.category = 'radio'
    assert question.optionable?
  end
end
