module Auth
  module Model::User
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :password_digest, :string
      attribute :locale, :string, default: I18n.default_locale
      attribute :timezone, :string
      attribute :last_login_at, :datetime
      attribute :last_login_ip, :string
      attribute :disabled, :boolean, default: false
      attribute :source, :string
      attribute :invite_code, :string, default: -> { SecureRandom.alphanumeric(32) }

      has_many :oauth_users
      has_many :sessions
      has_many :verify_tokens, through: :accounts
      has_many :accounts
      has_many :confirmed_accounts, -> { where(confirmed: true) }, class_name: 'Account'
      accepts_nested_attributes_for :accounts

      has_many :user_taggeds, dependent: :destroy_async
      has_many :user_tags, through: :user_taggeds
      has_many :user_invites

      has_one_attached :avatar

      validates :password, confirmation: true, length: { in: 6..72 }, allow_blank: true

      has_secure_password validations: false

      before_save :terminate_session, if: -> { password_digest_changed? }
      before_create :first_as_admin
      after_save_commit :sync_geo_by_ip, if: -> { saved_change_to_last_login_ip? && last_login_ip.present? }
    end

    def migrate_to(main_user)
      main_user = self.class.find(main_user) unless main_user.is_a? self.class
      self.class.const_get('MAP').each do |key, arr|
        arr.each do |model_klass|
          model_klass.where(key => id).find_each do |old|
            old.user = main_user
            old.save
          end
        end
      end
    end

    def migrate_from(temp_user)
      if temp_user.is_a? self.class
        user = temp_user
      else
        user = self.class.find(temp_user)
      end
      self.class.const_get('MAP').each do |key, arr|
        arr.each do |model_klass|
          model_klass.where(key => user.id).find_each do |old|
            old.user = self
            old.save
          end
        end
      end
    end

    ##
    # pass login params to this method;
    def can_login?(password)
      if disabled?
        errors.add :base, :account_disable
        return false
      end

      if authenticate(password)
        self.last_login_at = Time.current
        self.save
        self
      else
        errors.add :base, :wrong_name_or_password
        false
      end
    end

    def support_password_login?
      password_digest.present?
    end

    def info_blank?
      oauth_users.map(&:info_blank?).all? true
    end

    def first_as_admin
      self.admin = true if self.class.none?
    end

    def terminate_session
      self.sessions.destroy
    end

    def account_identities
      (confirmed_accounts.map(&:identity) + oauth_users.pluck(:identity).compact).uniq
    end

    def avatar_url
      avatar.url
    end

    def sync_geo_by_ip
      IpGeoJob.perform_later(self, last_login_ip)
    end

  end
end
