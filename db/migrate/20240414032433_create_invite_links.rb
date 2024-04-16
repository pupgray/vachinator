# frozen_string_literal: true

class CreateInviteLinks < ActiveRecord::Migration[7.1]
  def change
    create_table :invite_links do |t|
      t.string :code
      t.references :user, null: true, foreign_key: true
      t.references :herd, null: true, foreign_key: true
      t.integer :spaces_remaining, null: false, default: 69
      t.timestamp :expires_at, null: false

      t.timestamps
    end
  end
end
