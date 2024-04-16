# frozen_string_literal: true

class RenameTeamMembershipToHerdMembership < ActiveRecord::Migration[7.1]
  def change
    rename_table :team_memberships, :herd_memberships
    rename_column :herd_memberships, :team_id, :herd_id
  end
end
