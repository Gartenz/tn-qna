class ApplicationController < ActionController::Base
  before_action :gon_user, unless: :devise_controller?
  protect_from_forgery prepend: true
  check_authorization unless: :devise_controller?
  authorize_resource unless: :devise_controller?

  expose(:search_types) { [['All', nil], ['Questions', :question], ['Answers', :answer],['Comments', :comment], ['Users', :user]] }

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to main_app.new_user_session_url, notice: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

  private

  def gon_user
    gon.current_user_id = current_user.id if current_user
  end
end
