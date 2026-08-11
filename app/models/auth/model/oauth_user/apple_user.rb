module Auth
  module Model::OauthUser::AppleUser
    extend ActiveSupport::Concern

    included do
      attribute :provider, :string, default: 'apple'
    end

    def assign_info(oauth_params)
    end

    class_methods do

      def verify!(identity_token, audience:)
        header = JWT.decode(identity_token, nil, false).last
        jwk_hash = fetch_jwks.find { |k| k['kid'] == header['kid'] }
        raise "未知的 kid" unless jwk_hash

        public_key = JWT::JWK.import(jwk_hash).public_key
        payload, = JWT.decode(
          identity_token,
          public_key,
          true,
          algorithms: ['RS256'],
          iss: 'https://appleid.apple.com',
          verify_iss: true,
          aud: audience,
          verify_aud: true
        )
        payload # 包
      end

      def fetch_jwks
        Rails.cache.fetch('apple_jwks', expires_in: 1.day) do
          HTTPX.get('https://appleid.apple.com/auth/keys').json.fetch('keys', [])
        end
      end

    end

  end
end
