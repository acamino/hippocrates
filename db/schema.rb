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

ActiveRecord::Schema.define(version: 20160325031902) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "patients", force: :cascade do |t|
    t.integer  "medical_history",                  null: false
    t.string   "last_name",                        null: false
    t.string   "first_name",                       null: false
    t.string   "identity_card_number",             null: false
    t.datetime "birthdate",                        null: false
    t.integer  "gender",               default: 0, null: false
    t.integer  "civil_status",         default: 0, null: false
    t.string   "address"
    t.string   "profession"
    t.string   "phone_number"
    t.string   "email"
    t.integer  "source",               default: 0, null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "patients", ["civil_status"], name: "index_patients_on_civil_status", using: :btree
  add_index "patients", ["first_name"], name: "index_patients_on_first_name", using: :btree
  add_index "patients", ["gender"], name: "index_patients_on_gender", using: :btree
  add_index "patients", ["identity_card_number"], name: "index_patients_on_identity_card_number", using: :btree
  add_index "patients", ["last_name"], name: "index_patients_on_last_name", using: :btree
  add_index "patients", ["source"], name: "index_patients_on_source", using: :btree

end
