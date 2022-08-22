# frozen_string_literal: true

require 'test_helper'

class AnswerTest < ActiveSupport::TestCase
  test 'valid from factory' do
    answer = build :answer
    assert answer.valid?
    assert answer.save
  end
  test 'valid from factory with file' do
    answer = build :answer_file
    assert answer.valid?
    assert answer.save
  end
  test 'valid from factory with select' do
    answer = build :answer_select
    assert answer.valid?
    assert answer.save
  end
  test 'valid from factory with multiselect' do
    answer = build :answer_multiselect
    assert answer.valid?
    assert answer.save
  end

  # relations
  test 'belongs to request' do
    answer = create :answer
    assert_equal 'Request', answer.request.class.name
  end
  test 'belongs to question' do
    answer = create :answer
    assert_equal 'Question', answer.question.class.name
  end
  test 'has one file attached' do
    answer = create :answer
    assert_equal answer.file.class.to_s, 'ActiveStorage::Attached::One'
  end

  # Validations
  test 'presence of request' do
    answer = build :answer
    request = answer.request
    answer.request = nil
    assert_not answer.valid?
    answer.request = request
    assert answer.valid?
    assert answer.save
  end
  test 'presence of question' do
    answer = build :answer
    question = answer.question
    answer.question = nil
    assert_not answer.valid?
    answer.question = question
    assert answer.valid?
    assert answer.save
  end
  test 'question and request must be referenced to same profile' do
    answer = build :answer
    request = answer.request
    answer.request = create :request
    assert_not answer.valid?
    answer.request = request
    assert answer.valid?
    assert answer.save
  end
  test 'question uniqueness scoper request' do
    answer = create :answer
    duplicated = build :answer, question: answer.question, request: answer.request
    assert_not duplicated.valid?
    duplicated.request = create :request, profile: answer.request.profile
    assert duplicated.valid?
    assert duplicated.save
  end
  test 'presence of file when category is file' do
    answer = build :answer_file
    assert answer.valid?
    assert answer.save
    answer.file = nil
    assert_not answer.valid?
    assert_not answer.save
  end
  test 'absence of value when category is file' do
    answer = build :answer_file, value: 'test'
    assert_not answer.valid?
    answer.value = ''
    assert answer.valid?
    assert answer.save
  end
  test 'presence of value unless category is file' do
    answer = build :answer, value: ''
    assert_not answer.valid?
    answer.value = 'ok'
    assert answer.valid?
    assert answer.save
  end
  test 'absence of file unless category is file' do
    answer = build :answer_file, value: 'inutile'
    answer.question.update category: 'string'
    assert_not answer.valid?
    answer.file = nil
    assert answer.valid?
    assert answer.save
  end
  test 'value in acceptable options if selectable?' do
    answer = build :answer_select, value: 'other'
    assert_not answer.valid?
    answer.value = answer.options.where(acceptable: false).first.title 
    assert_not answer.valid?
    answer.value = answer.options.acceptable.first.title
    assert answer.valid?
    assert answer.save
  end
  test 'each value in options if multiselectable?' do
    answer = build :answer_multiselect, multivalue: ['other']
    assert_not answer.valid?
    answer.multivalue = answer.options.pluck :title
    assert_not answer.valid?
    answer.multivalue = answer.options.acceptable.pluck :title
    assert answer.valid?
    assert answer.save
  end
end
