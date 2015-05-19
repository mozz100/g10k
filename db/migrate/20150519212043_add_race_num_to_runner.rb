class AddRaceNumToRunner < ActiveRecord::Migration
  def change
    add_column :runners, :race_number, :integer
    add_column :runners, :thumbnail_url, :string
  end
end
