class ErrorsController < ApplicationController
  def not_found
    render json: { 'message' => 'page not found' }, status: 404
  end
end
