# frozen_string_literal: true

require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  test 'valid from factory' do
    profile = build :profile
    assert profile.valid?
    assert profile.save
  end
end
