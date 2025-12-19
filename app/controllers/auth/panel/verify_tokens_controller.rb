module Auth
  class Panel::VerifyTokensController < Panel::BaseController

    def index
      q_params = {}
      q_params.merge! params.permit(:identity, :type)

      @verify_tokens = VerifyToken.default_where(q_params).order(id: :desc).page(params[:page])
    end

  end
end
