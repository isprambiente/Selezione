# frozen_string_literal: true

require 'test_helper'

class AdditionTest < ActiveSupport::TestCase
  test 'valid from factory' do
    addition = build :addition
    assert addition.valid?
    assert addition.save
  end

  # Relations
  test 'belongs to request' do
    addition = create :addition
    assert_equal 'Request', addition.request.class.name
  end

  # Validations
  test 'presence of request' do
    addition = build :addition, request: nil
    assert_not addition.valid?
    addition.request = create :request
    assert addition.valid?
    assert addition.save
  end

  test 'presence of description' do
    addition = build :addition, description: ''
    assert_not addition.valid?
    addition.description = 'ok'
    assert addition.valid?
    assert addition.save
  end

  test 'readonly model if contest is sended' do
    addition = build :addition
    assert addition.update description: 'ok'
    addition.request.update status: :sended
    assert addition.valid?
    assert_raise(Exception) { assert_not addition.update(description: 'employer') }
    assert addition.readonly?
  end
end
