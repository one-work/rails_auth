module Auth
  module Model::AppView
    extend ActiveSupport::Concern

    included do
      attribute :session_id, :string, index: true
      attribute :view_at, :datetime, index: true
      attribute :starred, :boolean

      belongs_to :app
    end

  end
end
