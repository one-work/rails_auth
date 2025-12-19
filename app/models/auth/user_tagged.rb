module Auth
  class UserTagged < ApplicationRecord
    include Model::UserTagged
    include Notice::Ext::UserTagged if defined? RailsNotice
  end
end
