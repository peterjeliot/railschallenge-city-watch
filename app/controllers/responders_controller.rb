class RespondersController < ApplicationController
  def index
    responders = Responder.all.map(&:as_json)
    render json: { responders: responders }
  end

  def create
    @responder = Responder.new(responder_create_params)
    @responder.save!
    render json: @responder, root: true, status: 201
  rescue ActiveRecord::RecordInvalid
    render json: { 'message' => @responder.errors.messages }, status: 422
  rescue ActionController::UnpermittedParameters => e
    render json: { 'message' => e.message }, status: 422
  end

  def show
    @responder = Responder.find_by(name: params[:name])
    if @responder
      render json: @responder, root: true
    else
      render json: { error: 'Responder not found', name: params[:name] }, status: 404
    end
  end

  def update
    @responder = Responder.find_by(name: params[:name])
    @responder.update!(responder_update_params)
    render json: @responder, root: true, status: 200
  rescue ActiveRecord::RecordInvalid
    render json: { 'message' => @responder.errors.messages }, status: 422
  rescue ActionController::UnpermittedParameters => e
    render json: { 'message' => e.message }, status: 422
  end

  private

  def responder_create_params
    params.require(:responder).permit(:type, :name, :capacity)
  end

  def responder_update_params
    params.require(:responder).permit(:on_duty)
  end
end
