class CreateMailingLists < ActiveRecord::Migration
  def change
    create_table :mailing_lists do |t|
      t.string :name
      t.string :title

      t.timestamps null: false
    end
    add_index :mailing_lists, :name, unique: true
  end
end
