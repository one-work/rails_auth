module Auth
  class Board::AppsController < Board::BaseController

    def index
      @apps = App.where(creator_id: current_user.id).page(params[:page])
    end

    private
    def app_params
      _p = params.fetch(:app, {}).permit(
        :name,
        :host
      )
      _p.merge! creator_id: current_user.id
    end

  end
end
