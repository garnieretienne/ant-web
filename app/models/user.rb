class User < ActiveRecord::Base
  has_many :mailing_lists, foreign_key: :owner_id

  include ActiveModel::SecurePassword
  include EmailConcern

  has_secure_password

  validates :email, uniqueness: {case_sensitive: false}
end
