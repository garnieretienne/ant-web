class MailingList < ActiveRecord::Base

  # TODO: move the format validator in its own validator class.
  validates :name, presence: true, uniqueness: true,
    format: { with: /\A[a-zA-Z._-]+\z/}
  validates :title, presence: true

  def to_s
    title
  end

  def subscribers
    ["Etienne Garnier <vagrant@vagrant-ubuntu-trusty-64>"] # FIXME
  end

  def authorized_to_post?(email_address)
    true # FIXME
  end
end
