class ListIdValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    id_regex = /\A[a-zA-Z._-]+\.[0-9a-f]{32}\.[01][0-9]\d{4}.[a-z0-9\.-]+\z/
    unless value =~ id_regex
      record.errors[attribute] <<
        (options[:message] || "is not a valid list id")
    end
  end
end
