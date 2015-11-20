class User < ActiveRecord::Base
  has_many :subscriptions
  has_many :mailing_lists, foreign_key: "owner_id"

  validates :name, presence: true
  validates :email_address, presence: true, email: true,
    uniqueness: {case_sensitive: false}

  def to_s
    name
  end

  def email_with_name
    "#{name} <#{email_address}>"
  end
end
