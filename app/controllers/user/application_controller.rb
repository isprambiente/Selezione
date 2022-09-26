# frozen_string_literal: true

# This controller is the common anchestor and contain all shared methods for User module
#
# === Rescue
# RecordNotFound with {record_not_found!}
#
# == before_action
# * authenticate_user!
# * {check_right}
class User::ApplicationController < ApplicationController
  before_action :authenticate_user!
  before_action :check_right, except: :skip_check_right_list

  private

  # {ApplicationController.unauthorized!} if user_id is different from current user
  def check_right
    unauthorized! unless params[:user_id] == current_user.id.to_s
  end

  # list action that not require check_right
  def skip_check_right_list
    %i[]
  end
end
