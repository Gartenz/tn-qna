class AdditionalSignupsController < ApplicationController
  skip_authorization_check
  skip_authorize_resource

  def add_email_signup
  end

  def finish_signup
    auth = OmniAuth::AuthHash.new(provider: session[:oauth_provider],
                                  uid: session[:oauth_uid],
                                  info: { email: params[:user][:email] })
    session[:oauth_provider] = nil
    session[:oauth_uid] = nil
    user = User.find_for_oauth(auth)
    message = ''
    if user&.persisted?
      if user.confirmed?
        sign_in_and_redirect user, event: :authentication
      else
        redirect_to root_path, notice: 'Confirmation instructions was sent to your email'
      end
    end
  end
end
