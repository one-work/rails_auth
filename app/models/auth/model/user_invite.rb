module Auth
  module Model::UserInvite
    extend ActiveSupport::Concern

    included do
      attribute :code, :string, index: true

      belongs_to :user
    end

  end
end
