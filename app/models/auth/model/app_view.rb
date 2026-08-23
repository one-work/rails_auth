module Auth
  module Model::AppView
    extend ActiveSupport::Concern

    included do
      attribute :session_id, :string, index: true
      attribute :view_at, :datetime, index: true
      attribute :starred, :boolean

      belongs_to :app

      scope :viewed, -> { where.not(view_at: nil) }
    end

  end
end
