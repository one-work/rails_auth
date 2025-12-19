module Auth
  class VerifyTokenCleanJob < ApplicationJob

    def perform(verify_token)
      verify_token.destroy
    end

  end
end
