class RespondersController < ApplicationController
  def index
    if params[:show] == 'capacity'
      render json: all_capacities
    else
      responders = Responder.all.map(&:as_json)
      render json: { responders: responders }
    end
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
      routing_error
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

  def all_capacities
    {
      capacity: {
        Fire: capacity_for_type('Fire'),
        Police: capacity_for_type('Police'),
        Medical: capacity_for_type('Medical')
      }
    }
  end

  def capacity_for_type(type)
    restrictions = [
      { type: type },
      { type: type, emergency_code: nil },
      { type: type, on_duty: true },
      { type: type, emergency_code: nil, on_duty: true }
    ]
    restrictions.map do |restriction|
      Responder.where(restriction).sum(:capacity)
    end
  end
end
