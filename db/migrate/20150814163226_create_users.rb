class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.float :balance, default: 0
      t.string :trello_card
      t.timestamps null: false
    end
  end
end
