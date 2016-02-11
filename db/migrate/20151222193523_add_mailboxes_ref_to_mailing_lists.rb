class AddMailboxesRefToMailingLists < ActiveRecord::Migration
  def change
    add_reference :mailing_lists, :mailbox, index: true, foreign_key: true
  end
end
