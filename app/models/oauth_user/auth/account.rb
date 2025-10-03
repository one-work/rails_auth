module Auth
  class Account < OauthUser
    include Model::OauthUser::Account
    include Wechat::Ext::Account if defined? RailsWechat
    include Crm::Ext::Account if defined? RailsCrm
  end
end
