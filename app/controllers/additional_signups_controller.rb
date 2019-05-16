class AdditionalSignupsController < ApplicationController
  def add_email_signup
  end

  def finish_signup
    user = User.where(email: params[:user][:email]).first
    if user
      auth = current_user.authorizations.first.delete
      user.authorizations.create(provider: auth.provider, uid: auth.uid)
      d_user = current_user
      sign_out current_user
      if user.confirmed?
        sign_in user
      else
        user.send_confirmation_instructions
      end
      d_user.destroy
    else
      current_user.update(email: params[:user][:email])
      current_user.send_confirmation_instructions
      sign_out current_user
    end
    redirect_to root_path
  end
end
