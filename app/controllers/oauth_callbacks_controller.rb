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
    email =auth.info.email
    if email.nil?
      password = Devise.friendly_token[0, 20]
      user = User.create(email: "changeme.#{auth.credentials.expires_at}@email.com", password: password, password_confirmation: password)
    end
  end
end
