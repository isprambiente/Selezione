class User::SectionsController < User::ApplicationController
  include Requestable
  before_action :set_section

  # GET /user/:user_id/request/:user_request/sections/1
  def show
    partial_selector section: @section
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_section
      @section = @user_request.profile.sections.find(params[:id])
    end
end
