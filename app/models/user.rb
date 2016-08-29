class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
      :recoverable, :rememberable, :trackable, :validatable,
      :confirmable,
      :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many :identities, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :comments, dependent: :destroy

  class << self
    def find_for_oauth(auth)
      identity = Identity.where(provider: auth.provider, uid: auth.uid.to_s).first
      return identity.user if identity

      email = auth.info[:email]
      user = User.where(email: email).first
      unless user
        password = Devise.friendly_token(20)
        user = User.create!(email: email, password: password, password_confirmation: password)
      end
      user.identities.create(provider: auth.provider, uid: auth.uid) if user
      user
    end
  end
end
