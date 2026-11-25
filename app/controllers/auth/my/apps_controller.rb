module Auth
  class My::AppsController < My::BaseController

    private
    def app_params
      params.fetch(:app, {}).permit(
        :name,
        :appid,
        :key,
        :host,
        :note,
        :enabled,
        :logo
      )
    end

  end
end
