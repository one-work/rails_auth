module Auth
  class Board::UsersController < Board::BaseController
    before_action :set_user

    def create
      @user.assign_attributes user_params
      @user.save
    end

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
