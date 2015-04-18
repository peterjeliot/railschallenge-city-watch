class CreateResponders < ActiveRecord::Migration
  def change
    create_table :responders do |t|
      t.string :emergency_code
      t.string :type, null: false, index: true
      t.string :name, null: false
      t.integer :capacity, null: false, index: true
      t.boolean :on_duty, null: false, index: true

      t.timestamps null: false
    end
  end
end
