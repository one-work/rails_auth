module Auth
  class VerifyTokensController < BaseController
    before_action :set_new_verify_token, only: [:new, :create]

    def create
      @verify_token.save
    end

    private
    def set_new_verify_token
      if params[:identity].to_s.include?('@')
        @verify_token = EmailToken.new(params.permit(:identity))
      else
        @verify_token = MobileToken.new(params.permit(:identity))
      end
    end

  end
end