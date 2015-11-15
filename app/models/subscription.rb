class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :mailing_list

  validates :user, presence: true
  validates :mailing_list, presence: true
end
