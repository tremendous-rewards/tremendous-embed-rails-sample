class CreateCatalogs < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :tremendous_id
      t.string :name
      t.string :category
      t.string :country

      t.timestamps null: false
    end

    create_table :product_skus do |t|
      t.integer :roduct_id
      t.integer :min
      t.integer :max

      t.timestamps null: false
    end
  end
end
