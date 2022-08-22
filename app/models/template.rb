# frozen_string_literal: true

# this model manage data present for contests and her structure
#
# === Validations
# * presence of {title}
# * presence of {data}
#
# @!attribute [rw] id
#   @return [Integer] unique identifier
# @!attribute [rw] title
#   @return [String] descriptive title
# @!attribute [rw] data
#   @return [Hash] data structure for populate contest
class Template < ApplicationRecord
  validates :title, presence: true
  validates :data, presence: true

  default_scope { order('title asc') }
end
