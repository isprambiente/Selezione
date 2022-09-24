# app/controllers/concerns/requestable.rb
# This module extend all controllers under /users/:user_id/requests/:request_id and extend {Userable}
# 
#
# == before_action
# * authenticate_user!
# * {Userable.check_right}
# * {set_request}
# * {set_active}
module Requestable
  extend ActiveSupport::Concern

  included do
    before_action :set_prerequisite
    before_action :unauthorized!, except: %i[ index show ], unless: :editable?
  end

  private

  # Set {Request from params request_id}
  # @return [Object] {Request} istance
  def set_prerequisite
    @request = current_user.requests.includes(profile: { area: :contest }).find(params[:request_id])
    @editable = @request.editable?
  end

  # @return true if @request.editable?
  def editable?
    @editable
  end
end
