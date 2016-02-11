class Mailbox < ActiveRecord::Base
  has_one :owner, class_name: "MailingList"
  has_many :messages

  validates :name, presence: true, mailbox_name: true, uniqueness: true
  validates :owner, presence: true

  def self.find_by_address(address)
    a_name, a_domain = address.split("@")

    return nil unless a_domain == Rails.configuration.mail_domain

    self.find_by(name: a_name)
  end

  def to_s
    name
  end

  def email
    "#{name}@#{Rails.configuration.mail_domain}"
  end
end
