class CreateRecipes < ActiveRecord::Migration[6.0]
  def change
    create_table :recipes do |t|
      t.integer :dose
      t.integer :yield
      t.decimal :time, precision: 5, scale: 2
      t.references :brew_method, null: false, foreign_key: true
      t.references :coffee, null: false, foreign_key: true
      t.references :entry, null: false, foreign_key: true

      t.timestamps
    end
  end
end
