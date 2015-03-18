class CreateRunners < ActiveRecord::Migration
  def change
    create_table :runners do |t|
      t.string :name
      t.string :email
      t.decimal :expected_duration, scale: 2, precision: 8

      t.timestamps null: false
    end
  end
end
