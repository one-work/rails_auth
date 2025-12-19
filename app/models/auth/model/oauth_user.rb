module Auth
  module Model::OauthUser
    extend ActiveSupport::Concern

    included do
      attr_accessor :auth_appid

      attribute :type, :string
      attribute :provider, :string
      attribute :uid, :string, default: ''  # 防止 inner join 的时候出现空字符串
      attribute :unionid, :string, index: true
      attribute :appid, :string
      attribute :app_name, :string
      attribute :name, :string
      attribute :avatar_url, :string
      attribute :state, :string
      attribute :access_token, :string
      attribute :expires_at, :datetime
      attribute :refresh_token, :string
      attribute :extra, :json, default: {}
      attribute :identity, :string, default: ''
      attribute :online_at, :datetime
      attribute :offline_at, :datetime
      attribute :confirmed, :boolean
      attribute :source, :string

      index [:type, :uid, :identity], unique: true

      belongs_to :user, optional: true
      belongs_to :organ, class_name: 'Org::Organ', optional: true

      has_many :sessions, primary_key: [:uid, :appid, :identity, :user_id], foreign_key: [:uid, :appid, :identity, :user_id], dependent: :delete_all
      has_many :verify_tokens, primary_key: :identity, foreign_key: :identity, dependent: :delete_all

      belongs_to :same_oauth_user, ->(o) { where.not(id: o.id) }, class_name: self.name, foreign_key: :unionid, primary_key: :unionid, optional: true
      has_many :same_oauth_users, class_name: self.name, primary_key: :unionid, foreign_key: :unionid

      scope :without_user, -> { where(user_id: nil) }
      scope :with_user, -> { where.not(user_id: nil) }
      scope :confirmed, -> { where(confirmed: true) }

      normalizes :identity, with: -> (email) { email.strip.downcase }

      validates :identity, uniqueness: { scope: [:confirmed, :source, :id] }

      after_validation :init_user, if: -> { confirmed? && confirmed_changed? }
      before_save :auto_link, if: -> { unionid.present? && unionid_changed? }
      after_update :sync_to_authorized_tokens, if: -> { saved_change_to_identity? }
      after_save :sync_name_to_user, if: -> { name.present? && saved_change_to_name? }
      after_save_commit :sync_avatar_to_user_later, if: -> { avatar_url.present? && saved_change_to_avatar_url? }
    end

    def filter_hash
      {
        appid: appid,
        user_id: user_id,
        identity: identity,
        auth_appid: auth_appid
      }.compact_blank
    end

    def online?
      online_at.present? && offline_at.blank?
    end

    def can_login?(params)
      self.identity = params[:identity]
    end

    def init_user
      if same_oauth_user&.user
        auto_link
      else
        user || build_user
      end
    end

    def auto_link
      return unless same_oauth_user
      self.identity = identity.presence || same_oauth_user.identity
      self.user_id ||= same_oauth_user.user_id
      self.name ||= same_oauth_user.name
      self.avatar_url ||= same_oauth_user.avatar_url
    end

    def sync_name_to_user
      return unless user
      user.name ||= name
      user.save
    end

    def sync_avatar_to_user
      return unless user
      user.avatar.url_sync(avatar_url) unless user.avatar.attached?
    end

    def sync_avatar_to_user_later
      UserCopyAvatarJob.perform_later(self)
    end

    def info_blank?
      attributes['name'].blank? && attributes['avatar_url'].blank?
    end

    def sync_to_authorized_tokens
      sessions.update_all(identity: identity)
    end

    def save_info(info_params)
    end

    def strategy
    end

    def session
      sessions.effective.take || sessions.create
    end

    def auth_token
      session.id
    end

    def auth_jwt_token
      session.generate_jwt_token
    end

    def last?
      user.accounts.where.not(id: self.id).empty?
    end

    def can_login_by_token?(params)
      user || build_user
      user.assign_attributes params.slice(
        'name',
        'password',
        'password_confirmation',
        'invited_code'
      ) # 这里必须用 String 类型，因为params 转义过来的hash key 是字符
      user.last_login_at = Time.current
      self.confirmed = true

      self.class.transaction do
        user.save!
        self.save!
      end

      user
    end

    def can_login_by_password?(password)
      user.can_login?(password)
    end

    def once_token
      auth_token
    end

    def verify_token
      verify_tokens.find(&:effective?) || verify_tokens.create
    end

    def refresh_token!
      client = strategy
      token = OAuth2::AccessToken.new client, self.access_token, { expires_at: self.expires_at.to_i, refresh_token: self.refresh_token }
      token.refresh!
    end

  end
end
