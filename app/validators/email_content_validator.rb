class EmailContentValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless mandatory_headers_are_present?(value)
      record.errors[attribute] <<
        (options[:message] || "is not a valid email content")
    end
  end

  private

  def mandatory_headers_are_present?(value)
    value =~ /^Date:.*$/ &&
    value =~ /^From:.*$/ &&
    (value =~ /^To:.*$/ || value =~ /^Cc:.*$/ || value =~ /^Bcc:.*$/)
  end
end
