module Auth
  module Model::App
    extend ActiveSupport::Concern

    included do
      attribute :appid, :string, index: true
      attribute :key, :string, default: -> { SecureRandom.alphanumeric(32) }
      attribute :host, :string

      validates :host, presence: true
    end

  end
end
