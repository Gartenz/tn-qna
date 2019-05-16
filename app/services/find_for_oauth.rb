class Services::FindForOauth
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.where(email: email).first
    if user
      user.create_authorization(auth)
    else
      password = Devise.friendly_token[0, 20]
      if email
        user = User.create!(email: email, password: password, password_confirmation: password)
      else
        user = User.new(email: "changeme.#{auth.uid}@email.com", password: password, password_confirmation: password)
        user.skip_confirmation_notification!
        user.save
      end
      user.create_authorization(auth)
    end
    user
  end
end
