class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :author
      t.text :source
      t.references :mailing_list, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
