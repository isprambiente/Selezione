# frozen_string_literal: true

FactoryBot.define do
  factory :option do
    question { create :question, category: 'select' }
    weight { 0 }
    title { 'MyString' }
    acceptable { true }
  end
end
