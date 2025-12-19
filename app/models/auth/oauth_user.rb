module Auth
  class OauthUser < ApplicationRecord
    include Model::OauthUser
    include Org::Ext::OauthUser if defined? RailsOrg
  end
end
