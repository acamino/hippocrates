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

ActiveRecord::Schema.define(version: 20160524111217) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "anamneses", force: :cascade do |t|
    t.integer  "patient_id"
    t.string   "personal_history"
    t.string   "surgical_history"
    t.string   "allergies"
    t.string   "observations"
    t.string   "habits"
    t.string   "family_history"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "consultations", force: :cascade do |t|
    t.integer  "patient_id"
    t.string   "reason",               default: ""
    t.string   "ongoing_issue",        default: ""
    t.string   "organs_examination",   default: ""
    t.decimal  "temperature",          default: 0.0
    t.integer  "heart_rate",           default: 0
    t.decimal  "blood_pressure",       default: 0.0
    t.integer  "respiratory_rate",     default: 0
    t.decimal  "weight",               default: 0.0
    t.decimal  "height",               default: 0.0
    t.string   "physical_examination", default: ""
    t.string   "right_ear",            default: ""
    t.string   "left_ear",             default: ""
    t.string   "right_nostril",        default: ""
    t.string   "left_nostril",         default: ""
    t.string   "nasopharynx",          default: ""
    t.string   "nose_others",          default: ""
    t.string   "oral_cavity",          default: ""
    t.string   "oropharynx",           default: ""
    t.string   "hypopharynx",          default: ""
    t.string   "larynx",               default: ""
    t.string   "neck",                 default: ""
    t.string   "others",               default: ""
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "diagnoses", force: :cascade do |t|
    t.integer  "consultation_id"
    t.string   "disease_code"
    t.string   "description",                 null: false
    t.integer  "type",            default: 0, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "diseases", primary_key: "code", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "patients", force: :cascade do |t|
    t.integer  "medical_history",                      null: false
    t.string   "last_name",                            null: false
    t.string   "first_name",                           null: false
    t.string   "identity_card_number",                 null: false
    t.datetime "birthdate",                            null: false
    t.integer  "gender",               default: 0,     null: false
    t.integer  "civil_status",         default: 0,     null: false
    t.string   "address"
    t.string   "profession"
    t.string   "phone_number"
    t.string   "email"
    t.integer  "source",               default: 0,     null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.boolean  "special",              default: false, null: false
  end

  add_index "patients", ["civil_status"], name: "index_patients_on_civil_status", using: :btree
  add_index "patients", ["first_name"], name: "index_patients_on_first_name", using: :btree
  add_index "patients", ["gender"], name: "index_patients_on_gender", using: :btree
  add_index "patients", ["identity_card_number"], name: "index_patients_on_identity_card_number", unique: true, using: :btree
  add_index "patients", ["last_name"], name: "index_patients_on_last_name", using: :btree
  add_index "patients", ["medical_history"], name: "index_patients_on_medical_history", unique: true, using: :btree
  add_index "patients", ["source"], name: "index_patients_on_source", using: :btree
  add_index "patients", ["special"], name: "index_patients_on_special", using: :btree

  add_foreign_key "anamneses", "patients"
  add_foreign_key "consultations", "patients"
  add_foreign_key "diagnoses", "consultations"
  add_foreign_key "diagnoses", "diseases", column: "disease_code", primary_key: "code"
end
