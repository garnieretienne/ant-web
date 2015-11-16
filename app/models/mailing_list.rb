class MailingList < ActiveRecord::Base
  belongs_to :owner, class_name: User
  has_many :subscriptions
  has_many :subscribers, through: :subscriptions, source: :user

  # TODO: move the format validator in its own validator class.
  validates :owner, presence: true
  validates :name, presence: true, uniqueness: true,
    format: { with: /\A[a-zA-Z._-]+\z/}
  validates :title, presence: true

  def to_s
    title
  end

  # TODO: define different policies (owners only or every subscribers)
  def authorized_to_post?(email_address)
    subscribers.find_by(email_address: email_address)
  end
end
