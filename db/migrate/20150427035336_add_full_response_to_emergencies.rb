class AddFullResponseToEmergencies < ActiveRecord::Migration
  def change
    add_column :emergencies, :full_response, :boolean
  end
end
