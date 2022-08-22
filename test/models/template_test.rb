# frozen_string_literal: true

require 'test_helper'

class TemplateTest < ActiveSupport::TestCase
  test 'valid from factory' do
    template = build :template
    assert template.valid?
    assert template.save
  end

  # Validations
  test 'title is required' do
    template = build :template, title: nil
    assert_not template.valid?
    template.title = 'title'
    assert template.valid?
    assert template.save
  end

  test 'data is required' do
    template = build :template, data: nil
    assert_not template.valid?
    template.data = {}
    assert_not template.valid?
    template.data = []
    assert_not template.valid?
    template.data = { a: 'a' }
    assert template.valid?
  end

  # Scope
  test 'default_scope si by title' do
    t2 = create :template, title: 'b'
    t1 = create :template, title: 'a'
    assert_equal Template.all.first, t1
    assert_equal Template.all.last, t2
  end
end
