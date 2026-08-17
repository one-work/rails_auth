module Auth
  class AppsController < BaseController

    def index
      @apps = App.with_attached_logo.page(params[:page])
      @recent_apps = App.with_attached_logo.page(params[:page]).limit(4)
    end

  end
end