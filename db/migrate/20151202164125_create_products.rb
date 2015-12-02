class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :sku, index: true, null: false
      t.string :supplier_code, index: true, null: false
      t.text :field_1
      t.text :field_2
      t.text :field_3
      t.text :field_4
      t.text :field_5
      t.text :field_6
      t.decimal :price, precision: 2

      t.timestamps null: false
    end
  end
end
