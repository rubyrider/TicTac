# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151115215711) do

  create_table "boards", force: :cascade do |t|
    t.integer  "r1_c1"
    t.integer  "r1_c2"
    t.integer  "r1_c3"
    t.integer  "r2_c1"
    t.integer  "r2_c2"
    t.integer  "r2_c3"
    t.integer  "r3_c1"
    t.integer  "r3_c2"
    t.integer  "r3_c3"
    t.integer  "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "games", force: :cascade do |t|
    t.string   "name"
    t.integer  "player_id"
    t.integer  "opponent_id"
    t.integer  "result",         default: 1
    t.datetime "abandoned_at"
    t.datetime "started_at"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "status",         default: 1
    t.integer  "last_player_id"
  end

  add_index "games", ["opponent_id"], name: "index_games_on_opponent_id"

  create_table "moves", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "x_axis"
    t.integer  "y_axis"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "board_id"
  end

  add_index "moves", ["board_id"], name: "index_moves_on_board_id"
  add_index "moves", ["player_id"], name: "index_moves_on_player_id"

  create_table "players", force: :cascade do |t|
    t.string   "name"
    t.string   "icon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "point_tables", force: :cascade do |t|
    t.integer  "game_id"
    t.datetime "started_at"
    t.integer  "winner_id"
    t.string   "result"
    t.datetime "ended_at"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "looser_id"
    t.integer  "remaining_moves", default: 0
  end

  add_index "point_tables", ["looser_id"], name: "index_point_tables_on_looser_id"
  add_index "point_tables", ["winner_id"], name: "index_point_tables_on_winner_id"

end
