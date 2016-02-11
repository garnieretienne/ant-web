class MailboxNameValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A[a-z0-9.-]+\z/
      record.errors[attribute] << (
        options[:message] ||
        "must contain only lowercase alphanumeric and '-' characters"
      )
    end
  end
end
