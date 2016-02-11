class AddMailboxRefToMessages < ActiveRecord::Migration
  def change
    add_reference :messages, :mailbox, index: true
    add_foreign_key :messages, :mailbox, column: :mailbox_id
  end
end
