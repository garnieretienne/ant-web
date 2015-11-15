class Message < ActiveRecord::Base
  belongs_to :mailing_list

  validates :author, presence: true
  validates :source, presence: true
  validates :mailing_list, presence: true

  # TODO: Message can be sent to multiple lists.
  def self.new_from_source(message_string)
    parser = Mail.read_from_string(message_string)
    author = parser.from_addrs.any? && parser.from_addrs.first

    to_names = parser.to_addrs.map { |addr| addr.split('@').first }
    list =
      to_names.each do |name|
        if (current_list = MailingList.find_by(name: name))
          break current_list
        end
      end

    new(mailing_list: list, author: author, source: message_string)
  end

  def authorized?
    mailing_list.authorized_to_post?(author)
  end
end
