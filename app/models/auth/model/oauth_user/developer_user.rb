module Auth
  module Model::OauthUser::DeveloperUser
    extend ActiveSupport::Concern

    included do
      attribute :provider, :string, default: 'developer'
    end

    def assign_info(oauth_params)
    end

  end
end
