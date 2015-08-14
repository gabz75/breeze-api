class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  rescue_from ActiveRecord::RecordNotFound do |error|
    render json: error, status: :not_found
  end

  rescue_from ActionController::ParameterMissing do |exception|
    render json: error, status: :not_found
  end
end
