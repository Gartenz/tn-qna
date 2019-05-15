class AdditionalSignupsController < ApplicationController
  expose(:user_signup) { User.find(params[:id]) }

  def add_email_signup
  end

  def finish_signup
    user = User.where(email: params[:user][:email]).first
    if user
      auth = current_user.authorizations.first.delete
      user.authorizations.create(provider: auth.provider, uid: auth.uid)
      d_user = current_user
      sign_in user
      d_user.destroy
    else
      current_user.update(params[:user][:email])
    end
    redirect_to root_path
  end
end
