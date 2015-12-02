class CreateSuppliers < ActiveRecord::Migration
  def change
    create_table :suppliers do |t|
      t.string :code, index: true, uniq: true, null: false
      t.text :name

      t.timestamps null: false
    end
  end
end
