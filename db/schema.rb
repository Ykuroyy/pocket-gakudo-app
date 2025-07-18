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

ActiveRecord::Schema[8.0].define(version: 2025_07_08_063100) do
  create_table "attendance_histories", force: :cascade do |t|
    t.integer "attendance_id", null: false
    t.string "status", null: false
    t.text "message"
    t.string "child_name", null: false
    t.date "date", null: false
    t.string "parent_name", null: false
    t.string "changed_by", null: false
    t.datetime "changed_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attendance_id", "changed_at"], name: "index_attendance_histories_on_attendance_id_and_changed_at"
    t.index ["attendance_id"], name: "index_attendance_histories_on_attendance_id"
  end

  create_table "attendances", force: :cascade do |t|
    t.string "child_name"
    t.string "status"
    t.date "date"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "child_first_name"
    t.string "child_last_name"
    t.string "parent_name"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "password"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone"
    t.string "email"
    t.string "first_name"
    t.string "last_name"
  end

  add_foreign_key "attendance_histories", "attendances"
end
