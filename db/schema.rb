# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_04_14_232010) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "invite_links", force: :cascade do |t|
    t.string "code"
    t.bigint "user_id"
    t.bigint "team_id"
    t.integer "spaces_remaining", default: 69, null: false
    t.datetime "expires_at", precision: nil, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_invite_links_on_team_id"
    t.index ["user_id"], name: "index_invite_links_on_user_id"
  end

  create_table "matches", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.string "name"
    t.datetime "starts_at", precision: nil
    t.datetime "ends_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_matches_on_team_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "user_agent"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "team_memberships", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "user_id", null: false
    t.bigint "joined_with_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["joined_with_id"], name: "index_team_memberships_on_joined_with_id"
    t.index ["team_id"], name: "index_team_memberships_on_team_id"
    t.index ["user_id"], name: "index_team_memberships_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.bigint "captain_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["captain_id"], name: "index_teams_on_captain_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.boolean "verified", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "invite_links", "teams"
  add_foreign_key "invite_links", "users"
  add_foreign_key "matches", "teams"
  add_foreign_key "sessions", "users"
  add_foreign_key "team_memberships", "invite_links", column: "joined_with_id"
  add_foreign_key "team_memberships", "teams"
  add_foreign_key "team_memberships", "users"
  add_foreign_key "teams", "users", column: "captain_id"
end
