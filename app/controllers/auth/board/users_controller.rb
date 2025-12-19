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
      p = params.fetch(:user, {}).permit(
        :name,
        :bio,
        :avatar,
        :locale,
        :plate_number,
        :timezone
      )
      p.merge! user_extra_params
    end

    def user_extra_params
      defined?(super) ? super : {}
    end

  end
end
