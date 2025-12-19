module Auth
  class UserCopyAvatarJob < ApplicationJob

    def perform(oauth_user)
      oauth_user.sync_avatar_to_user
    end

  end
end
