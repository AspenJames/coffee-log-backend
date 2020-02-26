class CreateBrewMethods < ActiveRecord::Migration[6.0]
  def change
    create_table :brew_methods do |t|
      t.string :name

      t.timestamps
    end
  end
end
