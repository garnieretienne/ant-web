class User < ActiveRecord::Base
  has_many :mailing_lists, foreign_key: :owner_id

  include EmailConcern

  validates :email, uniqueness: {case_sensitive: false}
end
