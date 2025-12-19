module Auth
  module Model::VerifyToken::MobileToken
    extend ActiveSupport::Concern

    def update_token
      self.token = rand(100000..999999)
      super
      self
    end

    def send_out
      puts "sends sms here #{token}"
      true
    end

  end
end
