class User < ActiveRecord::Base
  has_many :mailing_lists

  include EmailConcern

  validates :email, uniqueness: {case_sensitive: false}
end
