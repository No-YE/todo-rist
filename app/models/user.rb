# frozen_string_literal: true

class User < ApplicationRecord
  include Discard::Model
  include Users::Attachable

  devise :database_authenticatable, :trackable, :omniauthable, :registerable,
         omniauth_providers: %w[google_oauth2]

  has_one :reminder_setting, dependent: :destroy, class_name: 'Users::ReminderSetting'
  has_one :summary_setting, dependent: :destroy, class_name: 'Users::SummarySetting'
  has_many :links, dependent: :destroy
  has_many :notifications, as: :recipient, dependent: :destroy, class_name: 'Noticed::Notification'

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
  validates :provider, presence: true, inclusion: { in: %w[google_oauth2] }
  validates :uid, presence: true, uniqueness: { scope: :provider }

  before_validation :downcase_email
  after_create_commit :notify_to_discord

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
      locale: access_token.extra['id_info']['locale'],
    )

    user.attach_avatar_from(data['image']) if user.valid? && user.avatar.blank?
    user
  end

  def as_json(options = {})
    super(options.merge(except: %i[admin password password_confirmation discarded_at]))
  end

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end

  def notify_to_discord
    text = <<~TEXT
      새로운 사용자가 생성되었습니다.
      name: #{name}, email: #{email}
      [link](#{Settings.host}/admin/data/users/#{id})
    TEXT

    Discordrb.charles_test_bot.send_message(
      Rails.application.credentials.dig(:discord, :charles_test, :channel_id),
      text,
    )
  end
end
