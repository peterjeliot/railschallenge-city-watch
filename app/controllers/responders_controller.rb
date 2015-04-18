class RespondersController < ApplicationController
  def create
    @responder = Responder.new(responder_params)
    if @responder.save
      render json: @responder
    else
      render json: { 'message' => { 'capacity' => ['is not included in the list'] } }, status: 422
    end
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
