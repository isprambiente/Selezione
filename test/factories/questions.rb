# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    section
    weight { 1 }
    title { 'MyText' }
    category { :string }
    mandatory { true }
    factory :question_file do
      category { :file }
    end
    factory :question_options do
      options_attributes { [{title: 'ok', acceptable: true},{title: 'yes', acceptable: true},{title: 'no', acceptable: false}]}
      factory :question_select do
        category { :select }
      end
      factory :question_multiselect do
        category { :multiselect }
      end
    end
  end
end
