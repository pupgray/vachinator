class RenameTeamToHerd < ActiveRecord::Migration[7.1]
  def change
    rename_table :herds, :herds
  end
end
