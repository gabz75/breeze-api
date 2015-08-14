class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.float :balance, default: 0
      t.string :trello_card
      t.boolean :delinquent, default: false
      t.datetime :last_delinquent_at
      t.timestamps null: false
    end
  end
end
