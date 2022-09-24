# frozen_string_literal: true

# This model manage the {Request} object. A {Request} is a job candidature
# to a {Contest}'s {Profile}.
#
# === Relations
# * belongs to {Profile}
# * belongs to {User}
# * has many {Answer}
# * has_many {Qualification}
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
# @!method area()
#   @return [Object] delegated from {Profile}, call refered {Area}
# @!method contest()
#   @return [Object] delegated from {Profile#contest}
class Request < ApplicationRecord
  STATUSES_ACTIVE = { editing: 'editing', sended: 'sended' }.freeze
  STATUSES_ENDED = { rejected: 'rejected', accepted: 'accepted', valutated: 'valutated' }.freeze
  STATUSES = STATUSES_ACTIVE.merge(STATUSES_ENDED)
  belongs_to :user
  belongs_to :profile
  has_many   :answers, dependent: :destroy
  has_many   :qualifications, dependent: :destroy
  has_many   :careers, dependent: :destroy
  has_many   :additions, dependent: :destroy

  delegate :active?, :ended?, :area, :contest, :qualifications_requested, :qualifications_requested?, :stop_at, to: :profile, allow_nil: true
  enum status: STATUSES, _prefix: true
  attr_accessor :confirm

  validates :user, presence: true
  validates :profile, presence: true
  validates :status,  presence: true
  validates :status, inclusion: { in: STATUSES_ENDED.values }, if: :ended?
  validates :status, inclusion: { in: STATUSES_ACTIVE.values }, if: :active?
  validates :confirm, acceptance: true, presence: true, if: :active?, on: :update

  with_options :active? do

  end

  with_options if: :status_sended? do
    validates :missing_answers?, absence: true
    validates :profile_conflicts?, absence: true
    validates :area_conflicts?, absence: true
    validates :qualification_required?, presence: true, if: :qualifications_requested?
    validates :careers_required?, presence: true
  end

  # Test if each required question has an answer
  # @return [Array] list of mandatory [Question] that have not an [Answer]
  def missing_answers?
    profile.questions.mandatory.pluck(:id) - answers.pluck(:question_id)
  end

  # Search other {Requests} from same {Area} and with same user
  # @return [Array] list of {Request}
  def other_user_area_requests
    area.requests.where(user: user).where.not(id: id).where.not(status: :editing)
  end

  # Test if there are conflicts with other requests on same profile
  # @return [Boolean] true if there are conflicts
  def profile_conflicts?
    area.profiles_max_choice <= other_user_area_requests.count
  end

  # Search other {Requests} from same {Contest} and with same user
  # @return [Array] list of {Request}
  def other_user_contest_requests
    contest.requests.where(user: user).where.not(areas: { id: profile.area_id }).where.not(status: :editing)
  end

  # Test if there are conflicts with requests on same contest
  # @return [Boolean] true if there are conflicts
  def area_conflicts?
    contest.areas_max_choice <= other_user_contest_requests.pluck('profiles.area_id').uniq.count
  end

  # Test if required qualification is present
  # @return [Boolean] true if exists
  def qualification_required?
    qualifications.exists?(category: qualifications_requested)
  end

  # test if required career is present
  # @return [Boolean] true if is present
  def careers_required?
    careers.total_countable_months >= profile.careers_requested
  end

  # print request code
  # @return [String] standardized code of request
  def code
    format '%06i', id
  end

  # prist request title
  # @return [String] title of request
  def title
    [code, contest.title].join ' | '
  end

  # cicle status_sended! and status_editing!
  # @return [Boolean] true if updated
  def switch!(confirmation=nil)
    self.confirm = confirmation
    status_editing? ? status_sended! : status_editing!
  end
  
  def editable?
    status_editing? && active?
  end
end
