module Auth
  class AppleUser < OauthUser
    include Model::OauthUser::AppleUser
  end
end
