# frozen_string_literal: true

# This model manage the {Addition} views
# Only authenticated users can access on this controller
# Each user access to this controller scoped by his user_id
#
# === before_action
# * authenticate_user! for all action
# * check_right! for all action
# * {set_addition} for {show}, {edit}, {update}, {destroy}
# * {set_request} for {index}
class User::AdditionsController < User::ApplicationController
  include Requestable
  before_action :set_addition, only: %i[ show edit update destroy ]

  # GET /users/:user_id/additions?request_id=:request_id
  def index
    @additions = @request.additions
    render partial: 'index' if turbo_frame_request?
  end

  # GET /additions/1 or /additions/1.json
  def show
    render partial: 'show' if turbo_frame_request?
  end

  # GET /additions/new
  def new
    @addition = Addition.new
    render partial: 'new' if turbo_frame_request?
  end

  # GET /additions/1/edit
  def edit
  end

  # POST /additions or /additions.json
  def create
    @addition = @request.additions.new(addition_params)

    if @addition.save
      redirect_to user_request_additions_url(current_user), notice: "Addition was successfully created." 
    else
      render :new, status: :unprocessable_entity 
    end
  end

  # PATCH/PUT /additions/1 or /additions/1.json
  def update
    if @addition.update(addition_params)
     redirect_to user_request_addition_url(current_user, @request, @addition), notice: "Addition was successfully updated."
    else
      render :edit, status: :unprocessable_entity 
    end
  end

  # DELETE /additions/1 or /additions/1.json
  def destroy
    @addition.destroy
    redirect_to user_request_additions_url(current_user, @request), notice: destroy_message(@addition) 
  end

  private
  
  # Set @request with params :request_id
  # @return [Object] {Request} istance
  def set_request
    @request = current_user.requests.find(params[:request_id])
  end

  # Set @addition with params :id
  # @return [Object] {Addition} istance
  def set_addition
    @addition = @request.additions.find(params[:id])
  end

  # set @additions from @request
  # @return [Object] ActiveRecord istance
  def set_additions
    @request.additions
  end

  # Filter params to manage {Addition}.
  def addition_params
    params.require(:addition).permit(:title, :description, :url, :file)
  end
end
