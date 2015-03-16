class AddRaceIdToRunner < ActiveRecord::Migration
  def change
    add_column :runners, :race_id, :int
  end
end
