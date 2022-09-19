# app/controllers/concerns/userable.rb
#
# This module extend all controllers undes /users/:user_id
#
# == before_action
# * authenticate_user!
# * {check_right}
module Userable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :check_right, except: :except_list
  end

  private

  # {ApplicationController.unauthorized!} if user_id is different from current user
  def check_right
    unauthorized! unless params[:user_id] == current_user.id.to_s
  end

  # list action that not require check_right
  def except_list
    %i[]
  end
end
