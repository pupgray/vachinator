class CreateTeamMemberships < ActiveRecord::Migration[7.1]
  def change
    create_table :team_memberships do |t|
      t.references :team, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :joined_with, null: false, foreign_key: { to_table: :invite_links }

      t.timestamps
    end
  end
end
