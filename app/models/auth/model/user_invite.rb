module Auth
  module Model::UserInvite
    extend ActiveSupport::Concern

    included do
      attribute :code, :string, index: true
      attribute :scene, :string

      belongs_to :user
      belongs_to :inviter, class_name: 'User'
    end

  end
end
