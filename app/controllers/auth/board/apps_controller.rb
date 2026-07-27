module Auth
  class Board::AppsController < Board::BaseController

    private
    def user_params
      params.fetch(:app, {}).permit(
        :name,
        :host
      )
    end

  end
end
