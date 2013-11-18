class SessionsController < ApplicationController
  before_action :set_session, only: [:show, :edit, :update, :destroy]
  
  def index
    @sessions = Session.all
    respond_with @sessions
  end

  def show
    respond_with @session
  end

  def edit
  end

  def create
    @session = Session.new(session_params)
    if @session.save
      render json: {id: @session.id}, status: 200
    end
  end

  # PATCH/PUT /sessions/1
  def update
    if @session.update(session_params)
      render json: {id: @session.id}, status: 200
    end
  end

  # DELETE /sessions/1
  def destroy
    @session.destroy
    redirect_to sessions_url, notice: 'Session was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_session
      @session = Session.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def session_params
      params[:session].permit(:skills)
    end
end
