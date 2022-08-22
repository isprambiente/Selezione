# frozen_string_literal: true

FactoryBot.define do
  factory :request do
    user
    profile
    status { 'editing' }
  end
end
