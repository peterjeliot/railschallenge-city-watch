class RespondersController < ApplicationController
  def index
    render json: Responder.all
  end

  def create
    @responder = Responder.new(responder_params)
    if @responder.save
      render json: @responder.json_format
    else
      # first_messages = .each { |k,v| v.replace [v[0]] }
      # byebug
      render json: { 'message' => @responder.errors.messages }, status: 422
    end
  rescue ActionController::UnpermittedParameters => e
    render json: { 'message' => e.message }, status: 422
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
