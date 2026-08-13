module Auth
  class AppsController < BaseController

    def index
      @apps = App.page(params[:page])
      @recent_apps = App.page(params[:page]).limit(4)
    end

  end
end