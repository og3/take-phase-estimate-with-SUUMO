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

ActiveRecord::Schema.define(version: 2021_08_22_011545) do

  create_table "emails", charset: "utf8mb4", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.boolean "ban", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "mitumori_logs", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "email_id"
    t.string "bukken_name"
    t.string "url"
    t.boolean "status", default: false
    t.text "shop_names"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email_id"], name: "index_mitumori_logs_on_email_id"
  end

  add_foreign_key "mitumori_logs", "emails"
end
