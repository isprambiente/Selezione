# frozen_string_literal: true

# This model manage the {Request} object. A {Request} is a job candidature
# to a {Contest}'s {Profile}.
#
# === Relations
# belongs to {Profile}
# belongs to {User}
# has many {Answer}
#
# === Validates
# * presence of {Profile}
# * presence of {User}
# * presence of {status}
# * presence of {active?} if status is editing or sended
# * presence of {ended?} if status is accepted, aborted, rejected, valutated
#
# @!attribute [rw] id
#   @return [Integer] unique identifier
# @!attribute [rw] profile_id
#   @return [Integer] {Profile} references
# @!attribute [rw] user_id
#   @return [String] {User} references
# @!attribute [Enumerable<Symbol>] status
#   @return [String] of status
# @!method active?()
#   @return [Boolean] delegated from {Profile#active?}
# @!method ended?()
#   @return [Boolean] delegated from {Profile#ended?}
class Request < ApplicationRecord
  STATUSES_ACTIVE = { editing: 'editing', sended: 'sended' }.freeze
  STATUSES_ENDED = { rejected: 'rejected', accepted: 'accepted', valutated: 'valutated' }.freeze
  STATUSES = STATUSES_ACTIVE.merge(STATUSES_ENDED)
  belongs_to :user
  belongs_to :profile
  has_many   :answers, dependent: :destroy

  delegate :active?, :ended?, to: :profile, allow_nil: true
  enum status: STATUSES, _prefix: true

  validates :user, presence: true
  validates :profile, presence: true
  validates :status,  presence: true
  validates :status, inclusion: { in: STATUSES_ACTIVE.values }, if: :active?
  validates :status, inclusion: { in: STATUSES_ENDED.values }, if: :ended?
  validates :missing_answers, absence: true, if: :status_sended?

  # Test if each required question has an answer
  # @return [Array] list of mandatory [Question] that have not an [Answer]
  def missing_answers?
    profile.questions.unscoped.mandatory.pluck(:id) - answers.pluck(:question_id)
  end

  # Test if there are conflicts with other requests on same profile
  # @return [Boolean] true if there are conflicts
  def profile_conflicts?
    profile.area.profiles_max_choice > Request.where(user: user, profile: profile.area.profiles)
  end

  # Test if there are conflicts with requests on same contest
  def area_conflicts?
  end
end
