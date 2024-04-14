class CreateInviteLinks < ActiveRecord::Migration[7.1]
  def change
    create_table :invite_links do |t|
      t.string :code, null: false
      t.references :user, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.integer :spaces_remaining, null: true
      t.timestamp :expires_at, null: false

      t.timestamps
    end
  end
end
