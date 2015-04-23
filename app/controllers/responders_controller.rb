class RespondersController < ApplicationController
  def index
    render json: Responder.all
  end

  def create
    @responder = Responder.new(responder_params)
    @responder.save!
    render json: @responder.json_format
  rescue ActiveRecord::RecordInvalid
    render json: { 'message' => @responder.errors.messages }, status: 422
  rescue ActionController::UnpermittedParameters => e
    render json: { 'message' => e.message }, status: 422
  end

  def show
    @responder = Responder.find_by(name: params[:name])
    if @responder
      render json: @responder.json_format
    else
      render json: { 'error': 'Responder not found', name: params[:name] }, status: 404
    end
  end

  private

  def responder_params
    params.require(:responder).permit(:type, :name, :capacity)
  end
end
