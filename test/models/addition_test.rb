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

  test 'presence of title' do
    addition = build :addition, title: ''
    assert_not addition.valid?
    addition.title = 'ok'
    assert addition.valid?
    assert addition.save
  end

  test 'readonly model if contest is sended' do
    addition = build :addition
    assert addition.update title: 'ok'
    addition.request.update status: :sended
    assert addition.valid?
    assert_raise(Exception) { assert_not addition.update(title: 'employer') }
    assert addition.readonly?
  end
end
