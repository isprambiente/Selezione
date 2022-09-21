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
  end

  # GET /additions/1 or /additions/1.json
  def show
  end

  # GET /additions/new
  def new
    @addition = Addition.new
  end

  # GET /additions/1/edit
  def edit
  end

  # POST /additions or /additions.json
  def create
    @addition = Addition.new(addition_params)

    respond_to do |format|
      if @addition.save
        format.html { redirect_to addition_url(@addition), notice: "Addition was successfully created." }
        format.json { render :show, status: :created, location: @addition }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @addition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /additions/1 or /additions/1.json
  def update
    respond_to do |format|
      if @addition.update(addition_params)
        format.html { redirect_to addition_url(@addition), notice: "Addition was successfully updated." }
        format.json { render :show, status: :ok, location: @addition }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @addition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /additions/1 or /additions/1.json
  def destroy
    @addition.destroy

    respond_to do |format|
      format.html { redirect_to additions_url, notice: "Addition was successfully destroyed." }
      format.json { head :no_content }
    end
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
    params.require(:addition).permit(:description, :url, :file)
  end
end
