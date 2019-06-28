class CreatePayouts < ActiveRecord::Migration
  def change
    create_table :payouts do |t|
      t.integer :reward_id
      t.integer :product_id
      t.string :tremendous_id

      t.string :status
      t.string :error
      t.text :data

      t.timestamps null: false
    end
  end
end
