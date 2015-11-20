class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :subscriber, index: true, foreign_key: true
      t.references :mailing_list, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
