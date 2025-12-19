module Auth
  module Ext::UserTagging
    extend ActiveSupport::Concern

    included do
      has_many :user_tags, as: :tagging
      after_create :xx
    end

    def config_user_tag
      UserTag.find_by(tagging_type: self.base_class_name)
    end

    def xx
      tag = user_tag || config_user_tag
      if tag
        tagged = user.user_taggeds.find_or_initialize_by(user_tag_id: tag.id)
        tagged.save
      end
    end

  end
end
