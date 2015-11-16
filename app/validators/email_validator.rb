class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A[^@\s]+@[-a-z0-9\.]+\z/i
      record.errors[attribute] << (options[:message] || "is not a valid email")
    end
  end
end
