class Message < ActiveRecord::Base
  belongs_to :mailbox

  attr_accessor :mailbox_address

  validates :author, presence: true
  validates :source, presence: true, email_content: true
  validates :mailbox, presence: true

  before_validation :find_mailbox

  def authorized?
    mailbox.authorized_to_post?(author)
  end

  private

  def find_mailbox
    return unless mailbox_address

    self.mailbox ||= Mailbox.find_by_address(mailbox_address)
  end
end
