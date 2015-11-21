class Subscriber < ActiveRecord::Base
  belongs_to :mailing_list

  validates :mailing_list, presence: true
  validates :name, presence: true
  validates :email, presence: true, email: true, uniqueness: {
    case_sensitive: false,
    scope: :mailing_list,
    message: "is already subscribed"
  }

  def to_s
    name
  end

  def email_with_name
    "#{name} <#{email}>"
  end
end
