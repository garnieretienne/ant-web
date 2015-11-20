class Subscription < ActiveRecord::Base
  belongs_to :subscriber
  belongs_to :mailing_list

  validates :subscriber, presence: true, uniqueness: {
    scope: :mailing_list,
    case_sensitive: false,
    message: "is already a subscriber"
  }
  validates :mailing_list, presence: true
end
