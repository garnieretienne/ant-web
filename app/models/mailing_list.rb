class MailingList < ActiveRecord::Base
  belongs_to :owner, class_name: User
  has_many :subscriptions
  has_many :subscribers, through: :subscriptions, source: :user

  # TODO: move the format validator in its own validator class.
  validates :owner, presence: true
  validates :uid, presence: true, list_id: true, uniqueness: true
  validates :name, presence: true, list_name: true, uniqueness: true
  validates :title, presence: true

  before_validation :generate_uid

  def to_s
    title
  end

  def list_id
    "#{title} <#{uid}>"
  end

  # TODO: define different policies (owners only or every subscribers)
  def authorized_to_post?(email_address)
    subscribers.find_by(email_address: email_address)
  end

  def subscribe(user_name, user_email)
    user = User.find_or_initialize_by(email_address: user_email) do |user|
      user.name = user_name
    end

    subscriptions.new(user: user)
  end

  private

  def generate_uid
    unless uid
      random = SecureRandom.hex(16)
      date = Time.now.strftime("%m%Y")
      self[:uid] = "#{name}.#{random}.#{date}.localhost"
    end
  end
end
