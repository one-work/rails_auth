module Auth
  module Model::Session
    extend ActiveSupport::Concern

    included do
      if connection.adapter_name == 'PostgreSQL'
        attribute :id, :uuid
      else
        attribute :id, :string, default: -> { SecureRandom.uuid_v7 }
      end
      attribute :ip_address, :string
      attribute :ip_city, :string
      attribute :user_agent, :string
      attribute :identity, :string, index: true
      attribute :expires_at, :datetime, default: -> { Time.current + 1.weeks }
      attribute :access_counter, :integer, default: 0
      attribute :mock_user, :boolean, default: false
      attribute :business, :string
      attribute :appid, :string
      attribute :uid, :string
      attribute :session_id, :string
      attribute :online_at, :datetime
      attribute :offline_at, :datetime
      attribute :encrypted_token, :string
      attribute :auth_appid, :string

      belongs_to :user, optional: true
      belongs_to :auth_app, class_name: 'App', foreign_key: :auth_appid, primary_key: :appid, optional: true
      belongs_to :oauth_user, foreign_key: [:uid, :identity], primary_key: [:uid, :identity], optional: true
      belongs_to :account, -> { where(confirmed: true) }, foreign_key: :identity, primary_key: :identity, optional: true

      has_many :sames, class_name: self.name, primary_key: [:identity, :uid, :session_id], foreign_key: [:identity, :uid, :session_id]

      scope :effective, -> { where('expires_at >= ?', Time.current).order(expires_at: :desc) }
      scope :expired, -> { where('expires_at < ?', Time.current) }

      generates_token_for :once, expires_in: 2.minutes

      before_validation :sync_identity, if: -> { uid.present? && uid_changed? }
      before_validation :sync_user_id, if: -> { identity.present? && identity_changed? }
      before_create :decode_from_jwt, if: -> { identity.blank? && uid.blank? }
      after_save :sync_online_or_offline, if: -> { uid.present? && (saved_changes.keys & ['online_at', 'offline_at']).present? }
      after_save_commit :online_job, if: -> { saved_change_to_online_at? }
      after_save_commit :set_ip_info!, if: -> { saved_change_to_ip_address? }
      after_create_commit :clean_when_expired
    end

    def once_token
      generate_token_for :once
    end

    def set_ip_info!
      if user
        user.update last_login_ip: ip_address
      end
      return if Rails.env.local?

      area = QqMapHelper.ip ip_address
      self.ip_city = area.dig('ad_info', 'city')
      self.save
    end

    def clean_when_expired
      AuthorizedTokenCleanJob.set(wait_until: expires_at).perform_later(self)
    end

    def online?
      online_at.present? && offline_at.blank?
    end

    def refresh!
      self.id = SecureRandom.uuid_v7
      self.expires_at = Time.current + 1.weeks
      self.save
    end

    def sync_online_or_offline
      oauth_user.update(online_at: online_at, offline_at: offline_at)
    end

    def online_job
      AuthorizedTokenOnlineJob.perform_later(self)
    end

    def sync_identity
      self.identity ||= oauth_user.identity
    end

    def sync_user_id
      self.user_id ||= account.user_id if account
    end

    def expired?(now = Time.current)
      return true if self.expires_at.blank?
      self.expires_at < now
    end

    def effective?(now = Time.current)
      expires_at.present? && expires_at > now
    end

    def verify_token?(now = Time.current)
      return false if self.expires_at.blank?
      if now > self.expires_at
        self.errors.add(:token, 'The token has expired')
        return false
      end

      true
    end

    def generate_jwt_token
      payload = {
        identity: identity,
        uid: uid
      }

      crypt = ActiveSupport::MessageEncryptor.new(
        auth_app.appid,
        cipher: 'aes-256-gcm',
        serializer: :json,
        urlsafe: true
      )
      crypt.encrypt_and_sign(payload)
    end

    # 应用在业务应用中
    def decode_from_jwt(token: Rails.configuration.x.appid)
      return unless encrypted_token
      crypt = ActiveSupport::MessageEncryptor.new(token, cipher: 'aes-256-gcm', serializer: :json)
      payload = crypt.decrypt_and_verify(encrypted_token)
      logger.debug "\e[35m  Decode From Token:#{payload}  \e[0m"
      self.uid = payload['uid']
      self.identity = payload['identity']
      init_oauth_user
      self.user = oauth_user.user
    end

    def init_oauth_user
      oauth_user || build_oauth_user(type: 'Wechat::WechatUser')
      oauth_user.init_user
      oauth_user.save
      oauth_user
    end

  end
end
