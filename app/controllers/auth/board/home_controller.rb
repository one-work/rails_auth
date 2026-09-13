module Auth
  class Board::HomeController < Board::BaseController

    def index
      @once_token = Current.session.once_token
    end

  end
end
