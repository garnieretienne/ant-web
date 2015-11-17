class ListNameValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A[a-z.-]+\z/
      record.errors[attribute] <<
        (options[:message] || "is not a valid list name")
    end
  end
end
