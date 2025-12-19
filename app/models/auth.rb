module Auth

  def self.use_relative_model_naming?
    true
  end

  def self.table_name_prefix
    'auth_'
  end

end
