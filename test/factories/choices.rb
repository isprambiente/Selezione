# frozen_string_literal: true

FactoryBot.define do
  factory :choice do
    question { nil }
    weight { 1 }
    title { 'MyString' }
  end
end
