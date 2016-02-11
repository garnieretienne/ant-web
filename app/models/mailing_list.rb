class MailingList < ActiveRecord::Base
  has_many :subscribers
  has_many :messages
  belongs_to :owner, class_name: "User"
  belongs_to :mailbox, autosave: true

  validates :uid, presence: true, list_id: true, uniqueness: true
  validates :name, presence: true
  validates :owner, presence: true
  validates :mailbox, presence: true

  before_validation :define_mailbox, :generate_uid

  attr_accessor :mailbox_name

  def to_s
    name
  end

  def list_id
    "#{name} <#{uid}>"
  end

  def email
    mailbox.email
  end

  def email_with_name
    "#{name} <#{email}>"
  end

  # TODO: define different policies (owners only or every subscribers)
  def authorized_to_post?(email)
    subscribers.find_by(email: email) != nil
  end

  private

  def define_mailbox
    self.mailbox ||= Mailbox.new(owner: self, name: mailbox_name)
  end

  def generate_uid
    unless uid
      random = SecureRandom.hex(16)
      date = Time.now.strftime("%m%Y")
      self.uid = "#{mailbox}.#{random}.#{date}.localhost"
    end
  end
end
