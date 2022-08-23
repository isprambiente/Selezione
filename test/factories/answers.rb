# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    question { create :question }
    request { question.present? ? create(:request, profile: question.section.profile) : nil }
    value { 'MyText' }
    factory :answer_file do
      question { create :question_file }
      value { '' }
      file { Rack::Test::UploadedFile.new('test/fixtures/files/Ruby_on_Rails-logo.png', 'image/png') }
    end
    factory :answer_select do
      question { create :question_select }
      value { 'ok' }
    end
    factory :answer_multiselect do
      question { create :question_multiselect }
      multivalue { %w[ok yes] }
    end
  end
end
