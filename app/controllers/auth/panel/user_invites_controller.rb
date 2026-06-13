module Auth
  class Panel::UserInvitesController < Panel::BaseController

    def index
      q_params = {}
      q_params.merge! params.permit(:identity, :type)

      @user_invites = @user.user_invites.default_where(q_params).order(id: :desc).page(params[:page])
    end

    private
    def set_user
      @user = User.find params[:user_id]
    end

  end
end
