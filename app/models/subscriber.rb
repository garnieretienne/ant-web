class Subscriber < ActiveRecord::Base
  belongs_to :mailing_list

  include EmailConcern

  validates :mailing_list, presence: true
  validates :email, uniqueness: {
    case_sensitive: false,
    scope: :mailing_list,
    message: "is already subscribed"
  }
end
