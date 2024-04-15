class MakeJoinedWithNillable < ActiveRecord::Migration[7.1]
  def change
    change_column_null :team_memberships, :joined_with_id, true
  end
end
