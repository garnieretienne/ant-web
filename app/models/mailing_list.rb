class MailingList < ActiveRecord::Base
  belongs_to :owner, class_name: Subscriber
  has_many :subscriptions
  has_many :subscribers, through: :subscriptions

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
  def authorized_to_post?(email)
    subscribers.find_by(email: email)
  end

  def subscribe(name, email)
    subscriber = Subscriber.find_or_initialize_by(email: email) do |s|
      s.name = name
    end
    
    subscriptions.new(subscriber: subscriber)
  end

  def unsubscribe(email)
    subscriber = Subscriber.find_by(email: email)
    return false unless subscriber

    subscription = subscriptions.find_by(subscriber: subscriber)
    return false unless subscription

    subscription.destroy
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
