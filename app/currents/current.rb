class Current < ActiveSupport::CurrentAttributes
  attribute :session
  delegate :user, :account, to: :session, allow_nil: true
end
