# frozen_string_literal: true

# This model manage the {Contest} object.
# A {Contest} represents a public contest for search one o more job profile.
#
# === Relations
# has many {Area}
# === Validates
# * presence of {code}
# * presence of {title}
# * presence of {start_at}
# * presence of {stop_at}
# * presence of {areas_max_choice}
# * numericality of {areas_max_choice}
#
# @!attribute [rw] id
#   @return [Integer] unique identifier
# @!attribute [rw] code
#   @return [String] public code
# @!attribute [rw] title
#   @return [String] Descriptive title
# @!attribute [rw] start_at
#   @return [Datetime] Publication date/time
# @!attribute [rw] stop_at
#   @return [Datetime] End date/time
# @!attribute [rw] areas_max_choice
#   @return [Integer] max requestable areas for {User}
# @!attribute [rw] areas_count
#   @return [Integer] counter cache value for {Area}
# @!attribute [rw] created_at
#   @return [DateTime] when the record was created
# @!attribute [rw] updated_at
#   @return [DateTime] when the record was updated
# @!attribute [rw] body
#  @return [Object] ActionText instance
#
# @!method self.future(opts = {time: Time.zone.now})
#   @param [Hash] opts options to be used in query
#   @option opts [Datetime] :time (Time.zone.now) start date for query
#   @return [Array] {Contest} not started in a specific moment
#   @example Future contest from now
#     Contest.future
#   @example Future contest from tomorrow
#     Contest.future(Time: Time.zone.now.tomorrow)
# @!method self.active(opts = {time: Time.zone.now})
#   @param [Hash] opts options to be used in query
#   @option opts [Datetime] :time (Time.zone.now) start date for query
#   @return [Array] {Contest} active in a specific moment
#   @example active contest now
#     Contest.active
#   @example Active contest tomorrow
#     Contest.active(Time: Time.zone.now.tomorrow)
# @!method self.ended(opts = {time: Time.zone.now})
#   @param [Hash] opts options to be used in query
#   @option opts [Datetime] :time (Time.zone.now) start date for query
#   @return [Array] {Contest} ended in a specific moment
#   @example Ended contest now
#     Contest.ended
#   @example Ended contest tomorrow
#     Contest.ended(Time: Time.zone.now.tomorrow)
# @!method self.published(opts = {time: Time.zone.now})
#   @param [Hash] opts options to be used in query
#   @option opts [Datetime] :time (Time.zone.now) start date for query
#   @return [Array] {Contest} started before a specific moment
#   @example published contest now
#     Contest.published
#   @example published contest tomorrow
#     Contest.published(Time: Time.zone.now.tomorrow)
class Contest < ApplicationRecord
  attr_accessor :template_id

  has_many :areas, dependent: :destroy
  has_many :profiles, through: :areas
  has_many :requests, through: :profiles, source: :area
  has_rich_text :body
  accepts_nested_attributes_for :areas

  validates :code, presence: true
  validates :title, presence: true
  validates :start_at, presence: true
  validates :stop_at, presence: true, comparison: { greater_than: :start_at }
  validates :areas_max_choice, presence: true, numericality: { only_integer: true, greater_than: 0 }
  before_validation :populate!, on: :create

  default_scope { order('start_at desc') }
  scope :future, ->(time: Time.zone.now) { where 'start_at > :time', time: time }
  scope :active, ->(time: Time.zone.now) { where 'start_at <= :time and stop_at >= :time', time: time }
  scope :ended, ->(time: Time.zone.now) { where 'stop_at < :time', time: time }
  scope :published, ->(time: Time.zone.now) { where 'start_at <= :time', time: time }

  # @return [Boolean] true if {#Contest} is started and not ended
  def active?
    start_at <= Time.now && stop_at >= Time.now
  end

  # @return [Boolean] true if {#Contest} is ended
  def ended?
    stop_at <= Time.now
  end

  private

  # call Template#populated if template_id is present
  # @return [Boolean] result of Template#populated
  def populate!
    assign_attributes Template.find(template_id).data if template_id.present?
  end
end
