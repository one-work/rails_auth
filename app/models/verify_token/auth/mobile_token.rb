module Auth
  class MobileToken < VerifyToken
    include Model::VerifyToken::MobileToken
  end
end
