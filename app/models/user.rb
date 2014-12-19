class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]

  has_one :profile

  include Authority::UserAbilities

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:email => data['email']).first

    unless user
      user = User.create(email: data['email'],
                         password: Devise.friendly_token[0, 20],
                         provider: access_token.provider,
                         uid: access_token.uid)
    end
    user
  end

  def self.find_for_facebook_oauth(auth)
    data = auth.info
    user = User.where(:email => data['email']).first

    unless user
      user = User.create(email: data['email'],
                         password: Devise.friendly_token[0, 20],
                         provider: auth.provider,
                         uid: auth.uid)
    end
    user
  end

end
