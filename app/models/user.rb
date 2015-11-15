class User < ActiveRecord::Base
  has_many :subscriptions
  has_many :mailing_lists, through: :subscriptions

  validates :name, presence: true
  validates :email_address, presence: true, email: true

  def to_s
    name
  end

  def email_with_name
    "#{name} <#{email_address}>"
  end
end
