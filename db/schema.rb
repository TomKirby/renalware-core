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

ActiveRecord::Schema.define(version: 20150109152145) do

  create_table "addresses", force: :cascade do |t|
    t.string   "street_1",   limit: 255
    t.string   "street_2",   limit: 255
    t.string   "county",     limit: 255
    t.string   "city",       limit: 255
    t.string   "postcode",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "drugs", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "type",       limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "edta_codes", force: :cascade do |t|
    t.integer  "code",        limit: 4
    t.string   "death_cause", limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "esrf_infos", force: :cascade do |t|
    t.integer  "patient_id",  limit: 4
    t.integer  "user_id",     limit: 4
    t.date     "date"
    t.integer  "prd_code_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ethnicities", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "modality_codes", force: :cascade do |t|
    t.string   "code",       limit: 255
    t.string   "name",       limit: 255
    t.string   "site",       limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "modality_reasons", force: :cascade do |t|
    t.string   "type",        limit: 255
    t.integer  "rr_code",     limit: 4
    t.string   "description", limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "patient_event_types", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",       limit: 255
    t.datetime "deleted_at"
  end

  create_table "patient_events", force: :cascade do |t|
    t.datetime "date_time"
    t.string   "user_id",               limit: 255
    t.string   "description",           limit: 255
    t.text     "notes",                 limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "patient_event_type_id", limit: 4
    t.integer  "patient_id",            limit: 4
  end

  create_table "patient_medications", force: :cascade do |t|
    t.integer  "patient_id",      limit: 4
    t.integer  "medication_id",   limit: 4
    t.integer  "user_id",         limit: 4
    t.string   "medication_type", limit: 255
    t.string   "dose",            limit: 255
    t.integer  "route",           limit: 4
    t.string   "frequency",       limit: 255
    t.text     "notes",           limit: 65535
    t.date     "date"
    t.integer  "provider",        limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "patient_modalities", force: :cascade do |t|
    t.integer  "patient_id",         limit: 4
    t.integer  "user_id",            limit: 4
    t.integer  "modality_code_id",   limit: 4
    t.integer  "modality_reason_id", limit: 4
    t.string   "modal_change_type",  limit: 255
    t.text     "notes",              limit: 65535
    t.date     "date"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "patients", force: :cascade do |t|
    t.string   "nhs_number",                   limit: 255
    t.string   "local_patient_id",             limit: 255
    t.string   "surname",                      limit: 255
    t.string   "forename",                     limit: 255
    t.date     "dob"
    t.boolean  "paediatric_patient_indicator", limit: 1
    t.integer  "sex",                          limit: 4,     default: 9
    t.integer  "current_address_id",           limit: 4
    t.integer  "address_at_diagnosis_id",      limit: 4
    t.string   "gp_practice_code",             limit: 255
    t.string   "pct_org_code",                 limit: 255
    t.string   "hosp_centre_code",             limit: 255
    t.string   "primary_esrf_centre",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ethnicity_id",                 limit: 4
    t.datetime "death_date"
    t.integer  "first_edta_code_id",           limit: 4
    t.integer  "second_edta_code_id",          limit: 4
    t.text     "death_details",                limit: 65535
  end

  create_table "problems", force: :cascade do |t|
    t.integer  "patient_id",  limit: 4
    t.string   "description", limit: 255
    t.date     "date"
    t.integer  "user_id",     limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "snomed_id",   limit: 255
  end

end
