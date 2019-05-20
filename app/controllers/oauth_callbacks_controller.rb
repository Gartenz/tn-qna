class OauthCallbacksController < Devise::OmniauthCallbacksController
  def oauth
    auth = request.env['omniauth.auth']
    user = User.find_for_oauth(auth)
    if user&.persisted?
      if user.confirmed?
        sign_in_and_redirect user, event: :authentication
        set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
      else
        redirect_to root_path, notice: 'You need to confirm your email'
      end
    else
      session[:oauth_provider] = auth.provider
      session[:oauth_uid] = auth.uid

      redirect_to add_email_signup_path
    end
  end

  alias_method :vkontakte, :oauth
  alias_method :github, :oauth
end
