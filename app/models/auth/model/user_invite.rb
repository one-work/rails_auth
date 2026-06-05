module Auth
  module Model::UserInvite
    extend ActiveSupport::Concern

    included do
      belongs_to :user
    end

  end
end
