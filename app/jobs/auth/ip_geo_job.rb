module Auth
  class IpGeoJob < ApplicationJob

    def perform(user, ip)
      user.set_geo_by_ip!(ip) if user.respond_to?(:set_geo_by_ip!)
    end

  end
end
