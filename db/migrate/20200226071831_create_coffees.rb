class CreateCoffees < ActiveRecord::Migration[6.0]
  def change
    create_table :coffees do |t|
      t.string :origin
      t.date :roast_date
      t.integer :price
      t.references :roaster, null: false, foreign_key: true

      t.timestamps
    end
  end
end
