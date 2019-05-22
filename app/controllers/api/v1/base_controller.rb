class Api::V1::BaseController < ApplicationController
  skip_authorization_check
  skip_authorize_resource

  before_action :doorkeeper_authorize!

  private

  def current_resource_onwer
    @current_resource_onwer ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
