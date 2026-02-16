# Deal with token
#
# 用于处理Token
module Auth
  module Model::VerifyToken
    extend ActiveSupport::Concern

    included do
      attribute :type, :string
      attribute :token, :string
      attribute :expires_at, :datetime
      attribute :identity, :string, index: true
      attribute :access_counter, :integer, default: 0
      attribute :uuid, :string, default: SecureRandom.uuid

      belongs_to :oauth_user, foreign_key: :identity, primary_key: :identity, optional: true
      has_one :user, through: :oauth_user

      scope :valid, -> { where('expires_at >= ?', 1.minutes.since).order(expires_at: :desc) }

      validates :token, presence: true
      validates :identity, presence: true

      after_initialize :update_token, if: -> { new_record? }
      after_create_commit :send_out
      after_create_commit :clean_when_expired
    end

    def clean_when_expired
      VerifyTokenCleanJob.set(wait_until: expires_at).perform_later(self)
    end

    def update_token
      self.token ||= SecureRandom.uuid
      self.expires_at = Time.current + 10.minutes
      self
    end

    def update_token!
      update_token
      save
      self
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

    def send_out
      raise 'should implement in subclass'
    end

  end
end
