# frozen_string_literal: true

# This model manage the {Career} object. A {Career} is a work experience refered to a {Request}
#
# === Relations
# * belongs to {Request}
#
# === Validations
# * presence of {Request}
# * presence of {employer}
# * presence of {category}
# * inclusion of {category} in CATEGORIES
# * presence of {description}
# * presence of {start_on}
# * presence of {stop_on}
# * {stop_on} minor or equal of {Contest.stop_at}
# * {start_on} minor of {stop_on}
#
# @!attribute [rw] id
#   @return [Integer] unique identifier
# @!attribute [rw] request_id
#   @return [Integer] {Request} reference
# @!attribute [rw] category
#   @return [String] category of career
# @!attribute [rw] employer
#   @return [String] name of employer
# @!attribute [rw] description
#   @return [String] description of the work experience
# @!attribute [rw] start_on
#   @return [Date] start of work experience
# @!attribute [rw] stop_on
#   @return [Date] end of work experience
class Career < ApplicationRecord
  CATEGORIES = { ti: 'ti', td: 'td', cc: 'cc', co: 'co', ar: 'ar', stage: 'stage', other: 'other' }.freeze
  include Readonlyalbe
  belongs_to :request

  enum category: CATEGORIES, _prefix: true

  validates :request, presence: true
  validates :employer, presence: true
  validates :category, presence: true, inclusion: { in: CATEGORIES.values }
  validates :description, presence: true
  validates :start_on, presence: true, comparison: { less_than: :stop_on }
  validates :stop_on, presence: true, comparison: { less_than_or_equal_to: :stop_at }
  validates :length, comparison: { greater_than: 14 }

  scope :start_on, -> { order 'start_on asc' }
  scope :countable, -> { where category: %w[ti td cc co ar] }

  # Count overlapped careers in monts
  # @return [Integer] months of career
  def self.total_countable_months
    list = start_on.countable
    total = 0
    tmp_start = Date.new
    tmp_stop = Date.new
    list.each do |c|
      total, tmp_start, tmp_stop = mount_sum(total, tmp_start, tmp_stop, c)
    end
    total + tmp_stop.-(tmp_start)./(30)
  end

  # sum join or sum mount for {total_countable_months}
  # @return [Array] mount, new tmp_start, new tmp_stop
  def self.mount_sum(total, tmp_start, tmp_stop, entry)
    if entry.start_on <= tmp_stop
      if entry.stop_on > tmp_stop
        [total, tmp_start, entry.stop_on]
      else
        [total, tmp_start, tmp_stop]
      end
    else
      [total + tmp_stop.-(tmp_start)./(30), entry.start_on, entry.stop_on]
    end
  end

  # length of work period in days
  # @return [Integer]
  def length
    if stop_on? && start_on
      stop_on.-(start_on).to_i
    else
      0
    end
  end
end
