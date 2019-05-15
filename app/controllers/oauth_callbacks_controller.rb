class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def vkontakte
    auth = request.env['omniauth.auth']
    email = auth.info.email
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    if authorization
      sign_in_and_redirect authorization.user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Vkontakte') if is_navigational_format?
      return
    end

    if email.nil?
      password = Devise.friendly_token[0, 20]
      user = User.create(email: "changeme.#{auth.credentials.expires_at}@email.com", password: password, password_confirmation: password)
      user.create_authorization(auth)
      sign_in user
      redirect_to add_email_signup_path(user)
    end
  end
end
