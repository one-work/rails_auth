module Auth
  module Model::App
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :appid, :string, index: true
      attribute :key, :string, default: -> { SecureRandom.alphanumeric(32) }
      attribute :host, :string

      belongs_to :creator, class_name: 'User', optional: true

      validates :host, presence: true
    end

  end
end
