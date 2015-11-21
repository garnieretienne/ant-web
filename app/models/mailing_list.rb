class MailingList < ActiveRecord::Base
  has_many :subscribers

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
    subscribers.new(name: name, email: email)
  end

  def unsubscribe(email)
    subscriber = subscribers.find_by(email: email)
    return false unless subscriber

    subscriber.destroy
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
