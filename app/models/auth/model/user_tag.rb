module Auth
  module Model::UserTag
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :user_taggeds_count, :integer, default: 0

      belongs_to :organ, class_name: 'Org::Organ', optional: true
      belongs_to :user_tagging, polymorphic: true, optional: true

      has_many :user_taggeds, dependent: :destroy_async
      has_many :users, through: :user_taggeds

      validates :name, presence: true
    end

  end
end
