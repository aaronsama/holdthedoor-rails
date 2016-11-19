class AccessesController < ApplicationController
  skip_before_action :authenticate_user!, only: :create
  skip_before_action :verify_authenticity_token, only: :create
  acts_as_token_authentication_handler_for User, only: :create, fallback: :exception

  before_action :set_access, only: [:show, :edit, :update, :destroy]

  # GET /accesses
  # GET /accesses.json
  def index
    @accesses = Access.all
  end

  # GET /accesses/1
  # GET /accesses/1.json
  def show
  end

  # GET /accesses/new
  def new
    @access = Access.new
  end

  # GET /accesses/1/edit
  def edit
  end

  # POST /accesses
  # POST /accesses.json
  def create
    @access = Access.new(access_params)

    respond_to do |format|
      if @access.save
        format.html { redirect_to @access, notice: 'Access was successfully created.' }
        format.json { render :show, status: :created, location: @access }
      else
        format.html { render :new }
        format.json { render json: @access.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accesses/1
  # PATCH/PUT /accesses/1.json
  def update
    respond_to do |format|
      if @access.update(access_params)
        format.html { redirect_to @access, notice: 'Access was successfully updated.' }
        format.json { render :show, status: :ok, location: @access }
      else
        format.html { render :edit }
        format.json { render json: @access.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accesses/1
  # DELETE /accesses/1.json
  def destroy
    @access.destroy
    respond_to do |format|
      format.html { redirect_to accesses_url, notice: 'Access was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_access
      @access = Access.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def access_params
      params.require(:access).permit(:openedWith, :user)
    end
end
