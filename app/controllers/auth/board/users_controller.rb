module Auth
  class Board::UsersController < Board::BaseController
    before_action :set_user, only: [:show, :update]

    private
    def set_user
      @user = current_user
    end

    def user_params
      params.fetch(:user, {}).permit(
        :name,
        :avatar,
        :locale,
        :timezone
      )
    end

  end
end
