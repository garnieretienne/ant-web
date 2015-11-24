class AddOwnerRefToMailingLists < ActiveRecord::Migration
  def change
    add_reference :mailing_lists, :owner, index: true
    add_foreign_key :mailing_lists, :users, column: :owner_id
  end
end
