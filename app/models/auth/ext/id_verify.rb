module Auth
  module Ext::IdVerify
    extend ActiveSupport::Concern

    included do
      attribute :verify_status, :boolean, default: false
      attribute :verify_message, :json
      attribute :verify_result, :string

      validates :id_number, uniqueness: true, allow_blank: true

      before_validation :upcase_id_number

      scope :verified, -> { where(verify_status: true) }
    end

    def secret_id_number
      if self.id_number.present?
        replace_length = id_number.length - 4
        replace_length = 3 if replace_length < 1
       "#{id_number.first(2)}#{'*' * replace_length }#{id_number.last(2)}"
      end
    end

    def upcase_id_number
      self.id_number = self.id_number.to_s.upcase
    end

    def verify_id_number
      r = IdCheckHelper.do_verify(id_number, auth_name)
      if r.dig('result', 'res') == '1'
        self.verify_status = true
      else
        self.verify_status = false
      end
      self.verify_message = r['message']
      self.verify_result = r['result']
    end

  end
end
