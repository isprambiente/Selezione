# frozen_string_literal: true

# this controller manage the {Request} views.
# Only authenticated users can access to this controller
#
# === Before action
# * authenticate_user! for all action
# * {set_request} for {show}, {edit}, {update}, {destroy}
# * {set_requests} for {index}
class RequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_request, only: %i[show edit update]
  before_action :set_requests, only: %i[index]
  before_action :check_right, only: %i[show edit update]

  # GET /requests or /requests.json
  def index
    respond_to do |format|
      format.turbo_stream { render 'index' }
      format.html {}
    end
  end

  # GET /requests/1 or /requests/1.json
  def show; end

  # GET /requests/1/edit
  def edit; end

  # POST /requests or /requests.json
  def create
    @request = current_user.requests.find_or_create_by(profile_id: create_request_params[:profile_id])
    if @request.persisted?
      redirect_to request_url(@request)
    else
      record_not_found
    end
  end

  # PATCH/PUT /requests/1 or /requests/1.json
  def update
    if @request.switch!(update_request_params[:confirm])
      redirect_to request_url(@request), notice: 'Request was successfully updated.'
    else
      redirect_to request_url(@request), aliert: 'Request updated fail'
    end
  end

  # DELETE /requests/1 or /requests/1.json
  def destroy
    @request.destroy

    respond_to do |format|
      format.html { redirect_to requests_url, notice: 'Request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Set @request from param :id
  def set_request
    @request = Request.includes(profile: { area: :contest }).find(params[:id])
    @profile = @request.profile
    @area = @profile.area
    @contest = @area.contest
  end

  # Deny access if request is not afferent to current user
  def check_right
    unauthorized! unless @request.try(:user) == current_user
  end

  # Set @pagy, @contests filtered by {filter_params}
  def set_requests
    @text = ['profiles.title ilike :text or area.title ilike :text or contest.title ilike :test', { text: "%#{filter_params[:text]}%" }] if filter_params[:text].present?
    @pagy, @requests = pagy(current_user.requests.includes(profile: { area: :contest }).where(@text).order('contests.stop_at desc'), items: 12)
  end

  # Filter params for contests search
  def filter_params
    params.fetch(:filter, {}).permit(:text)
  end

  # Filter params for create {Request}
  def create_request_params
    params.require(:request).permit(:profile_id)
  end

  # Filter params for create {Request}
  def update_request_params
    params.require(:request).permit(:confirm)
  end

end
