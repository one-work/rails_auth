module Auth
  class AuthorizedTokenCleanJob < ApplicationJob

    def perform(authorized_token)
      authorized_token.destroy
    end

  end
end
