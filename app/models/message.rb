class Message < ActiveRecord::Base
  belongs_to :mailing_list

  validates :author, presence: true
  validates :source, presence: true, email_content: true
  validates :mailing_list, presence: true

  # TODO: Message can be sent to multiple lists.
  def self.new_from_source(message_string)
    message = new(source: message_string)
    parser = Mail.read_from_string(message.source)

    message.author = parser.from_addrs.any? && parser.from_addrs.first

    recipients = []
    recipients += parser.to.map { |addr| addr.split('@').first } if parser.to
    recipients += parser.cc.map { |addr| addr.split('@').first } if parser.cc

    recipients.each do |name|
      if (current_list = MailingList.find_by(name: name))
        message.mailing_list = current_list
      end
    end

    message
  end

  def authorized?
    mailing_list.authorized_to_post?(author)
  end
end
