class CreateEmergencies < ActiveRecord::Migration
  def change
    create_table :emergencies do |t|
      t.string :code, null: false
      t.integer :fire_severity, null: false, index: true
      t.integer :police_severity, null: false, index: true
      t.integer :medical_severity, null: false, index: true
      t.timestamp :resolved_at

      t.timestamps null: false
    end
  end
end
