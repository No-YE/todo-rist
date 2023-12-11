# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :trackable, :omniauthable, omniauth_providers: %w[google_oauth2]

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    user ||= User.create(
      name: data['name'],
      email: data['email'],
      image: data['image'],
      password: Devise.friendly_token[0, 20],
      provider: access_token.provider,
      uid: access_token.uid
    )
    user
  end
end
