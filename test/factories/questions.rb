# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    section { nil }
    weigth { 1 }
    title { 'MyText' }
    type { 1 }
    mandatory { false }
  end
end
