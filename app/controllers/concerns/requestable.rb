# frozen_string_literal: true

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
    before_action :unauthorized!, except: %i[index show], unless: :editable?
  end

  private

  # Set {Request from params request_id}
  # @return [Object] {Request} istance
  def set_prerequisite
    @request = current_user.requests.includes(profile: { area: :contest }).find(params[:request_id])
    @user_request = @request
    @editable = @request.editable?
  end

  # @return true if @request.editable?
  def editable?
    @editable
  end

  def partial_selector(my_action_name = action_name, **new_options)
    options = { user_request: @request, editable: @editable, my_action_name: my_action_name }.merge new_options
    if turbo_frame_request?
      render partial: my_action_name, locals: options
    else
      render action: 'requestable', locals: options
    end
  end
end
