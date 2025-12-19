module Auth
  class GithubUser < OauthUser
    include Model::OauthUser::GithubUser
  end
end
