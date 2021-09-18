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

ActiveRecord::Schema.define(version: 2021_09_15_111954) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "btree_gin"
  enable_extension "plpgsql"

  create_table "anamneses", id: :serial, force: :cascade do |t|
    t.integer "patient_id"
    t.string "medical_history"
    t.string "surgical_history"
    t.string "allergies"
    t.string "observations"
    t.string "habits"
    t.string "family_history"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "hearing_aids", default: false, null: false
  end

  create_table "attachments", force: :cascade do |t|
    t.bigint "document_id"
    t.jsonb "content_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_id"], name: "index_attachments_on_document_id"
  end

  create_table "consultations", id: :serial, force: :cascade do |t|
    t.integer "patient_id"
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
    t.string "warning_signs"
    t.datetime "next_appointment"
    t.boolean "special_patient", default: false, null: false
    t.string "hearing_aids", default: ""
    t.integer "oxygen_saturation", default: 0
    t.text "recommendations"
    t.bigint "user_id"
    t.string "serial"
    t.index ["special_patient"], name: "index_consultations_on_special_patient"
    t.index ["user_id"], name: "index_consultations_on_user_id"
  end

  create_table "diagnoses", id: :serial, force: :cascade do |t|
    t.integer "consultation_id"
    t.string "disease_code"
    t.string "description", null: false
    t.integer "type", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "diseases", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_diseases_on_code", unique: true
  end

  create_table "documents", force: :cascade do |t|
    t.bigint "consultation_id"
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["consultation_id"], name: "index_documents_on_consultation_id"
  end

  create_table "medicines", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "instructions", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_medicines_on_name", unique: true
  end

  create_table "patients", id: :serial, force: :cascade do |t|
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
    t.text "health_insurance"
    t.index ["civil_status"], name: "index_patients_on_civil_status"
    t.index ["first_name", "last_name"], name: "index_patients_on_first_name_and_last_name", using: :gin
    t.index ["gender"], name: "index_patients_on_gender"
    t.index ["identity_card_number"], name: "index_patients_on_identity_card_number", unique: true
    t.index ["medical_history"], name: "index_patients_on_medical_history", unique: true
    t.index ["source"], name: "index_patients_on_source"
    t.index ["special"], name: "index_patients_on_special"
  end

  create_table "prescriptions", id: :serial, force: :cascade do |t|
    t.integer "consultation_id"
    t.string "inscription", null: false
    t.string "subscription", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "settings", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_settings_on_name", unique: true
  end

  create_table "users", id: :serial, force: :cascade do |t|
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
    t.boolean "admin", default: false, null: false
    t.boolean "super_admin", default: false, null: false
    t.boolean "active", default: true, null: false
    t.string "first_name"
    t.string "last_name"
    t.string "pretty_name"
    t.string "phone_number"
    t.string "registration_acess"
    t.string "speciality"
    t.integer "serial", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["registration_acess"], name: "index_users_on_registration_acess", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "anamneses", "patients"
  add_foreign_key "attachments", "documents", on_delete: :cascade
  add_foreign_key "consultations", "patients"
  add_foreign_key "consultations", "users", on_delete: :nullify
  add_foreign_key "diagnoses", "consultations"
  add_foreign_key "documents", "consultations", on_delete: :cascade
  add_foreign_key "prescriptions", "consultations"
end
