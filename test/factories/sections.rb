# frozen_string_literal: true

FactoryBot.define do
  factory :section do
    profile
    title { 'MyString' }
    top { 'top_text' }
    bottom { 'bottom_text' }
    weight { 0 }
  end
end
