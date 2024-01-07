# frozen_string_literal: true

class User < ApplicationRecord
  include Discard::Model

  devise :database_authenticatable, :trackable, :omniauthable, :registerable,
         omniauth_providers: %w[google_oauth2]

  has_many :links, dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
  validates :provider, presence: true, inclusion: { in: %w[google_oauth2] }
  validates :uid, presence: true, uniqueness: { scope: :provider }

  before_validation :downcase_email

  after_discard -> { links.discard_all }

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    user ||= User.create(
      name: data['name'],
      email: data['email'],
      image: data['image'],
      password: Devise.friendly_token[0, 20],
      provider: access_token.provider,
      uid: access_token.uid,
    )
    user
  end

  def as_json(options = {})
    super(options.merge(except: %i[password password_confirmation]))
  end

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end
end
