module EmailConcern
  extend ActiveSupport::Concern

  included do
    validates :name, presence: true
    validates :email, presence: true, email: true
  end

  def to_s
    name
  end

  def email_with_name
    "#{name} <#{email}>"
  end
end
