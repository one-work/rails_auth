module Auth
  module Model::UserInvite
    extend ActiveSupport::Concern

    included do
      attribute :code, :string, index: true, default: -> { SecureRandom.alphanumeric(32) }

      belongs_to :user
    end

  end
end
