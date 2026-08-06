module Auth
  module Model::App
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :appid, :string, index: true
      attribute :key, :string, default: -> { SecureRandom.alphanumeric(32) }
      attribute :host, :string
      attribute :note, :string

      belongs_to :creator, class_name: 'User', optional: true

      has_one_attached :logo

      validates :host, presence: true
    end

    def url
      if host.start_with? 'http'
        _host = host
      else
        _host = "https://#{host}"
      end
      URI(_host).to_s
    end

  end
end
