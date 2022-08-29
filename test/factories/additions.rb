FactoryBot.define do
  factory :addition do
    request
    description { "MyText" }
    url { "https://test.it" }
    file { Rack::Test::UploadedFile.new('test/fixtures/files/Ruby_on_Rails-logo.png', 'image/png') }
  end
end
