module Auth
  class Panel::AppsController < Panel::BaseController

    private
    def app_permit_params
      [
        :appid,
        :key,
        :host
      ]
    end

  end
end
