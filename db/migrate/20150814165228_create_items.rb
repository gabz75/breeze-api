class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.belongs_to :user
      t.string :item_type
      t.float :amount
      t.timestamps null: false
    end
  end
end
