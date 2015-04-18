class RespondersController < ApplicationController
  def index
    render json: Responder.all
  end

  def create
    @responder = Responder.new(responder_params)
    if @responder.save
      render json: @responder
    else
      render json: { 'message' => @responder.errors.messages }, status: 422
    end
  rescue ActionController::UnpermittedParameters
    render json: { 'message' => 'found unpermitted parameter: emergency_code' }, status: 422
  end

  def show
    @responder = Responder.find(params[:id])
    render json: @responder
  end

  private

  def responder_params
    params.require(:responder).permit(:type, :name, :capacity)
  end
end
