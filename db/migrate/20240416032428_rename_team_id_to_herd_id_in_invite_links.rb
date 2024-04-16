# frozen_string_literal: true

class RenameTeamIdToHerdIdInInviteLinks < ActiveRecord::Migration[7.1]
  def change
    rename_column :invite_links, :team_id, :herd_id
    rename_column :matches, :team_id, :herd_id
  end
end
