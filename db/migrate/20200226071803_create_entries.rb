class CreateEntries < ActiveRecord::Migration[6.0]
  def change
    create_table :entries do |t|
      t.date :date
      t.text :prep_notes
      t.text :description
      t.integer :rating

      t.timestamps
    end
  end
end
