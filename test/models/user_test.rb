# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'valid from factory' do
    user = build :user
    assert user.valid?
    assert user.save
  end

  ### relations
  # test 'has many requests' do
  #  user = create :users
  #  assert_equal 'ActiveRecord::Associations::CollectionProxy', section.questions.class.name
  #  assert_equal 'Request', user.requests.new.class.name
  # end

  ### Validations
  test 'tax_code is required' do
    user = build :user, tax_code: ''
    assert_not user.valid?
    user.tax_code = 'test'
    assert user.valid?
    assert user.save
  end

  test 'name is required' do
    user = build :user, name: ''
    assert_not user.valid?
    user.name = 'test'
    assert user.valid?
    assert user.save
  end

  test 'surname' do
    user = build :user, surname: ''
    assert_not user.valid?
    user.surname = 'test'
    assert user.valid?
    assert user.save
  end

  ### scope
  test 'default scope is suranme, name' do
    u0 = create :user, name: 'a', surname: 'a'
    u1 = create :user, name: 'b', surname: 'a'
    u2 = create :user, name: 'a', surname: 'b'
    assert_equal User.all[0], u0
    assert_equal User.all[1], u1
    assert_equal User.all[2], u2
  end
end
