require 'byebug'
class EmergenciesController < ApplicationController
  def index
    emergencies = Emergency.all.map(&:as_json)
    render json: { emergencies: emergencies }
  end

  def create
    @emergency = Emergency.new(emergency_create_params)
    @emergency.save!
    dispatch_responders(@emergency)
    render json: @emergency.to_json, status: 201
  rescue ActiveRecord::RecordInvalid
    render json: { 'message' => @emergency.errors.messages }, status: 422
  rescue ActionController::UnpermittedParameters => e
    render json: { 'message' => e.message }, status: 422
  end

  def show
    @emergency = Emergency.find_by(code: params[:code])
    if @emergency
      render json: @emergency
    else
      routing_error
    end
  end

  def update
    @emergency = Emergency.find_by(code: params[:code])
    @emergency.update!(emergency_update_params)
    render json: @emergency, status: 200
  rescue ActiveRecord::RecordInvalid
    render json: { 'message' => @emergency.errors.messages }, status: 422
  rescue ActionController::UnpermittedParameters => e
    render json: { 'message' => e.message }, status: 422
  end

  private

  def emergency_create_params
    params.require(:emergency).permit(:code, :fire_severity, :police_severity, :medical_severity)
  end

  def emergency_update_params
    params.require(:emergency).permit(:resolved_at, :fire_severity, :police_severity, :medical_severity)
  end
end
