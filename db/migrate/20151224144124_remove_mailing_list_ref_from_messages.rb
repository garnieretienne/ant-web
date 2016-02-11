class RemoveMailingListRefFromMessages < ActiveRecord::Migration
  def change
    remove_column :messages, :mailing_list_id, :integer
  end
end
