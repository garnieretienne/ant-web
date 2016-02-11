class RemoveTitleFromMailingLists < ActiveRecord::Migration
  def change
    remove_column :mailing_lists, :title, :string
  end
end
