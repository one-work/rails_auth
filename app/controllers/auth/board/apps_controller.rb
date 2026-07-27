module Auth
  class Board::AppsController < Board::BaseController

    def index
      @apps = App.where(creator_id: current_user.id).page(params[:page])
    end

    private
    def user_params
      params.fetch(:app, {}).permit(
        :name,
        :host
      )
    end

  end
end
