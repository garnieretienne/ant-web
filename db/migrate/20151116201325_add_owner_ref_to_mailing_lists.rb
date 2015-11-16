class AddOwnerRefToMailingLists < ActiveRecord::Migration
  def change
    add_reference :mailing_lists, :owner, index: true, foreign_key: true
  end
end
