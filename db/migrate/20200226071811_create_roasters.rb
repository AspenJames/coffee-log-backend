class CreateRoasters < ActiveRecord::Migration[6.0]
  def change
    create_table :roasters do |t|
      t.string :name

      t.timestamps
    end
  end
end
