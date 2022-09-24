# frozen_string_literal: true

FactoryBot.define do
  factory :addition do
    request
    title { 'MyTitle' }
    description { 'MyText' }
    url { 'https://test.it' }
    file { Rack::Test::UploadedFile.new('test/fixtures/files/Ruby_on_Rails-logo.png', 'image/png') }
  end
end
