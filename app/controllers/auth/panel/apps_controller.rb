module Auth
  class Panel::AppsController < Panel::BaseController

    private
    def app_params
      params.fetch(:app, {}).permit(
        :name,
        :appid,
        :key,
        :host
      )
    end

  end
end
