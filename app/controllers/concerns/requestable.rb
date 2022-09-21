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
    before_action :set_request #, only: :set_request_list
  end

  private

  # Set {Request from params request_id}
  # @return [Object] {Request} istance
  def set_request
    @request = current_user.requests.includes(profile: { area: :contest }).find(request_param)
  end

  # Filter params to get request_id
  def request_param
    params.require(:request_id)
  end

  def set_request_list
    %i[ index ]
  end
end
