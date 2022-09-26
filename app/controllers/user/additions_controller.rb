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
    @additions = @user_request.additions
    partial_selector additions: @additions
  end

  # GET /additions/1 or /additions/1.json
  def show
    partial_selector addition: @addition
  end

  # GET /additions/new
  def new
    @addition = Addition.new
    partial_selector addition: @addition
  end

  # GET /additions/1/edit
  def edit
    partial_selector addition: @addition
  end

  # POST /additions or /additions.json
  def create
    @addition = @user_request.additions.new(addition_params)

    if @addition.save
      redirect_to user_request_additions_url(current_user), notice: "Addition was successfully created." 
    else
      partial_selector 'new', addition: @addition
    end
  end

  # PATCH/PUT /additions/1 or /additions/1.json
  def update
    if @addition.update(addition_params)
     redirect_to user_request_addition_url(current_user, @user_request, @addition), notice: "Addition was successfully updated."
    else
      partial_selector 'edit', addition: @addition
    end
  end

  # DELETE /additions/1 or /additions/1.json
  def destroy
    @addition.destroy
    redirect_to user_request_additions_url(current_user, @user_request), notice: destroy_message(@addition) 
  end

  private

  # Set @addition with params :id
  # @return [Object] {Addition} istance
  def set_addition
    @addition = @user_request.additions.find(params[:id])
  end

  # Filter params to manage {Addition}.
  def addition_params
    params.require(:addition).permit(:title, :description, :url, :file)
  end
end
