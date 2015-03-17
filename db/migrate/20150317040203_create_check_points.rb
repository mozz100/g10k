class CreateCheckPoints < ActiveRecord::Migration
  def change
    create_table :check_points do |t|
      t.integer :runner_id
      t.decimal :percent
      t.datetime :check_time

      t.timestamps null: false
    end
  end
end
