class CreateRunners < ActiveRecord::Migration
  def change
    create_table :runners do |t|
      t.string :name
      t.string :email
      t.decimal :expected_duration

      t.timestamps null: false
    end
  end
end
