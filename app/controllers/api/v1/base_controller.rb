class Api::V1::BaseController < ActionController::Base
  before_action :doorkeeper_authorize!
  check_authorization
  authorize_resource 

  rescue_from CanCan::AccessDenied do |exception|
    head :forbidden
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    head :bad_request
  end

  private

  def current_resource_onwer
    @current_resource_onwer ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def current_ability
    @current_ability ||= Ability.new(current_resource_onwer)
  end
end
