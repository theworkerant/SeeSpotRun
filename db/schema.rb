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

ActiveRecord::Schema.define(version: 20131016171458) do

  create_table "conditions", force: true do |t|
    t.string   "name"
    t.string   "category"
    t.integer  "point_basis"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "session_skills", force: true do |t|
    t.integer  "session_id"
    t.integer  "skill_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "session_skills", ["session_id"], name: "index_session_skills_on_session_id", using: :btree
  add_index "session_skills", ["skill_id"], name: "index_session_skills_on_skill_id", using: :btree

  create_table "sessions", force: true do |t|
    t.integer  "user_id"
    t.integer  "routine_id"
    t.boolean  "is_template"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["routine_id"], name: "index_sessions_on_routine_id", using: :btree
  add_index "sessions", ["user_id"], name: "index_sessions_on_user_id", using: :btree

  create_table "skill_conditions", force: true do |t|
    t.integer  "skill_id"
    t.integer  "condition_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "skill_conditions", ["condition_id"], name: "index_skill_conditions_on_conditions_id", using: :btree
  add_index "skill_conditions", ["skill_id"], name: "index_skill_conditions_on_skill_id", using: :btree

  create_table "skill_restricted_conditions", force: true do |t|
    t.integer  "skill_id"
    t.integer  "condition_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "skill_restricted_conditions", ["condition_id"], name: "index_skill_restricted_conditions_on_condition_id", using: :btree
  add_index "skill_restricted_conditions", ["skill_id"], name: "index_skill_restricted_conditions_on_skill_id", using: :btree

  create_table "skills", force: true do |t|
    t.string   "name"
    t.string   "category"
    t.integer  "point_basis"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
