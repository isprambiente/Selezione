# frozen_string_literal: true

# app/models/concerns/weightable.rb
module Weightable
  extend ActiveSupport::Concern

  included do
    scope :by_weight, -> { order('weight desc') }
  end

  # def trash
  #   update_attribute :trashed, true
  # end
end
