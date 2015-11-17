class AddUidToMailingLists < ActiveRecord::Migration
  def change
    add_column :mailing_lists, :uid, :string
  end
end
