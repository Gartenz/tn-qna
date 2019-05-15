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
    user = User.find_for_oauth(request.env['omniauth.auth'])
    redirect_to root_path, alert: 'Something went wrong' and return unless user

    if user.confirmed?
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Vkontakte') if is_navigational_format?
    else
      sign_in user
      redirect_to add_email_signup_path(user)
    end
  end
end
