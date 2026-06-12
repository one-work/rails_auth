module Auth
  class User < ApplicationRecord
    include Model::User
    include Roled::Ext::User
    MAP = {}.freeze
  end
end
