module Auth
  class VerifyTokensController < BaseController
    before_action :set_new_verify_token, only: [:new, :create]

    def create
      @verify_token.save
    end

    private
    def set_new_verify_token
      @verify_token = VerifyToken.new(verify_token_params)
    end

    def verify_token_params
      params.permit(
        :identity
      )
    end

  end
end