# frozen_string_literal: true

# default mailer class
# This class contain all methods and configuration shared for any mailer
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
