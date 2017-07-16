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

ActiveRecord::Schema.define(version: 20160713023856) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "anamneses", force: :cascade do |t|
    t.bigint "patient_id"
    t.string "medical_history"
    t.string "surgical_history"
    t.string "allergies"
    t.string "observations"
    t.string "habits"
    t.string "family_history"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_anamneses_on_patient_id"
  end

  create_table "consultations", force: :cascade do |t|
    t.bigint "patient_id"
    t.string "reason", default: ""
    t.string "ongoing_issue", default: ""
    t.string "organs_examination", default: ""
    t.decimal "temperature", default: "0.0"
    t.integer "heart_rate", default: 0
    t.string "blood_pressure", default: ""
    t.integer "respiratory_rate", default: 0
    t.decimal "weight", default: "0.0"
    t.decimal "height", default: "0.0"
    t.string "physical_examination", default: ""
    t.string "right_ear", default: ""
    t.string "left_ear", default: ""
    t.string "right_nostril", default: ""
    t.string "left_nostril", default: ""
    t.string "nasopharynx", default: ""
    t.string "nose_others", default: ""
    t.string "oral_cavity", default: ""
    t.string "oropharynx", default: ""
    t.string "hypopharynx", default: ""
    t.string "larynx", default: ""
    t.string "neck", default: ""
    t.string "others", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "miscellaneous"
    t.string "diagnostic_plan"
    t.string "treatment_plan"
    t.string "educational_plan"
    t.datetime "next_appointment"
    t.boolean "special_patient", default: false, null: false
    t.string "hearing_aids", default: ""
    t.index ["patient_id"], name: "index_consultations_on_patient_id"
    t.index ["special_patient"], name: "index_consultations_on_special_patient"
  end

  create_table "diagnoses", force: :cascade do |t|
    t.bigint "consultation_id"
    t.string "disease_code"
    t.string "description", null: false
    t.integer "type", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["consultation_id"], name: "index_diagnoses_on_consultation_id"
  end

  create_table "diseases", id: false, force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_diseases_on_code", unique: true
  end

  create_table "medicines", force: :cascade do |t|
    t.string "name", null: false
    t.string "instructions", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_medicines_on_name", unique: true
  end

  create_table "patients", force: :cascade do |t|
    t.integer "medical_history", null: false
    t.string "last_name", null: false
    t.string "first_name", null: false
    t.string "identity_card_number", null: false
    t.datetime "birthdate", null: false
    t.integer "gender", default: 0, null: false
    t.integer "civil_status", default: 0, null: false
    t.string "address"
    t.string "profession"
    t.string "phone_number"
    t.string "email"
    t.integer "source", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "special", default: false, null: false
    t.index ["civil_status"], name: "index_patients_on_civil_status"
    t.index ["first_name"], name: "index_patients_on_first_name"
    t.index ["gender"], name: "index_patients_on_gender"
    t.index ["identity_card_number"], name: "index_patients_on_identity_card_number", unique: true
    t.index ["last_name"], name: "index_patients_on_last_name"
    t.index ["medical_history"], name: "index_patients_on_medical_history", unique: true
    t.index ["source"], name: "index_patients_on_source"
    t.index ["special"], name: "index_patients_on_special"
  end

  create_table "prescriptions", force: :cascade do |t|
    t.bigint "consultation_id"
    t.string "inscription", null: false
    t.string "subscription", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["consultation_id"], name: "index_prescriptions_on_consultation_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "name", null: false
    t.string "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_settings_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "anamneses", "patients"
  add_foreign_key "consultations", "patients"
  add_foreign_key "diagnoses", "consultations"
  add_foreign_key "prescriptions", "consultations"
end
