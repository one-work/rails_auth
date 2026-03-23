module Auth
  class Board::AccountsController < Board::BaseController
    before_action :set_account, only: [:destroy]

    def index
      @accounts = current_user.accounts.order(id: :asc)
    end

    def create
      if params[:identity].to_s.include?('@')
        @verify_token = EmailToken.new(params.permit(:identity))
      else
        @verify_token = MobileToken.new(params.permit(:identity))
      end

      unless @verify_token.save
        render :edit, locals: { model: @account }, status: :unprocessable_entity
      end
    end

    def confirm
      @token = VerifyToken.valid.find_by(identity: params[:identity], token: params[:token])

      if @token
        @account = current_user.accounts.build(identity: params[:identity])
        @account.confirmed = true
        @account.save
      else
        render 'alert_message', status: :unauthorized, locals: { message: '验证码错误！' }
      end
    end

    private
    def set_account
      @account = current_user.accounts.find(params[:id])
    end

  end
end
