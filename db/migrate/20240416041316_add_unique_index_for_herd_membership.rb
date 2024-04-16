# frozen_string_literal: true

class AddUniqueIndexForHerdMembership < ActiveRecord::Migration[7.1]
  def change
    add_index :herd_memberships, %i[user_id herd_id], unique: true
  end
end
