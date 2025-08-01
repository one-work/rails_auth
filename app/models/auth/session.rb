module Auth
  class Session < ApplicationRecord
    include Model::Session
    include Org::Ext::Session if defined? RailsOrg
    include Wechat::Ext::Session if defined? RailsWechat
  end
end
