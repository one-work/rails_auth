module Auth
  class VerifyTokensController < BaseController
    skip_before_action :require_authentication
    before_action :set_new_verify_token, only: [:new, :create]

    def new
    end

    def create
      @verify_token.save
    end

    private
    def set_new_verify_token
      @verify_token = VerifyToken.new(verify_token_params)
    end

    def verify_token_params
      params.permit(
        :mobile_number
      )
    end

  end
end