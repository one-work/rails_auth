module Auth
  class AppsController < BaseController

    def index
      @apps = App.page(params[:page])
    end

  end
end