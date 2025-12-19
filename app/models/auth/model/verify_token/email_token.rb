module Auth
  module Model::VerifyToken::EmailToken
    extend ActiveSupport::Concern

    def update_token
      self.token = rand(10000..999999)
      super
      self
    end

    def send_out
      UserMailer.email_token(self.identity, self.token).deliver_later
    end

  end
end
