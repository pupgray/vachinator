# frozen_string_literal: true

class CreateMatches < ActiveRecord::Migration[7.1]
  def change
    create_table :matches do |t|
      t.references :herd, null: false, foreign_key: true
      t.string :name
      t.timestamp :starts_at
      t.timestamp :ends_at

      t.timestamps
    end
  end
end
