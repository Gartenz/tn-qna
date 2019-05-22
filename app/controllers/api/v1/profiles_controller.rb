class Api::V1::ProfilesController < ApplicationController
  skip_authorization_check
  skip_authorize_resource

  before_action :doorkeeper_authorize!

  def me
    render json: current_resource_onwer
  end

  private

  def current_resource_onwer
    @current_resource_onwer ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
