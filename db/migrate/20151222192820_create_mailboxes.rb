class CreateMailboxes < ActiveRecord::Migration
  def change
    create_table :mailboxes do |t|
      t.string :name, index: true

      t.timestamps null: false
    end
  end
end
