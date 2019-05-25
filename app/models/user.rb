class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable,
         :omniauthable, omniauth_providers: %i[github vkontakte]

  has_many :questions
  has_many :answers
  has_many :rewards
  has_many :votes
  has_many :authorizations, dependent: :destroy
  has_many :comments, dependent: :destroy

  def admin?
    self.admin
  end

  def author_of?(resource)
    self.id == resource.user_id
  end

  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
