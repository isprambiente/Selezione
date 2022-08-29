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

ActiveRecord::Schema[7.0].define(version: 2022_08_29_085454) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "career_categories", ["ti", "td", "cc", "co", "ar", "stage", "other"]
  create_enum "qualification_categories", ["dsg", "lvo", "lb", "lm", "phd", "training"]
  create_enum "question_categories", ["string", "text", "select", "multiselect", "radio", "checkbox", "file"]
  create_enum "request_statuses", ["editing", "sended", "aborted", "rejected", "accepted", "valutated"]

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "additions", force: :cascade do |t|
    t.bigint "request_id", null: false
    t.text "description", default: "", null: false
    t.string "url", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["request_id"], name: "index_additions_on_request_id"
  end

  create_table "answers", force: :cascade do |t|
    t.bigint "request_id", null: false
    t.bigint "question_id", null: false
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_answers_on_question_id"
    t.index ["request_id", "question_id"], name: "index_answers_on_request_id_and_question_id", unique: true
    t.index ["request_id"], name: "index_answers_on_request_id"
  end

  create_table "areas", force: :cascade do |t|
    t.bigint "contest_id", null: false
    t.string "code", default: "", null: false
    t.string "title", default: "", null: false
    t.integer "profiles_max_choice", default: 1, null: false
    t.integer "profiles_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_areas_on_code"
    t.index ["contest_id"], name: "index_areas_on_contest_id"
    t.index ["title"], name: "index_areas_on_title"
  end

  create_table "careers", force: :cascade do |t|
    t.bigint "request_id", null: false
    t.string "employer"
    t.enum "category", default: "ti", enum_type: "career_categories"
    t.text "description", default: "", null: false
    t.date "start_on", null: false
    t.date "stop_on", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_careers_on_category"
    t.index ["request_id"], name: "index_careers_on_request_id"
    t.index ["start_on"], name: "index_careers_on_start_on"
  end

  create_table "contests", force: :cascade do |t|
    t.string "code", limit: 10, null: false
    t.string "title", null: false
    t.datetime "start_at", null: false
    t.datetime "stop_at", null: false
    t.integer "areas_max_choice", default: 1, null: false
    t.integer "areas_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_contests_on_code"
    t.index ["start_at"], name: "index_contests_on_start_at"
    t.index ["stop_at"], name: "index_contests_on_stop_at"
    t.index ["title"], name: "index_contests_on_title"
  end

  create_table "options", force: :cascade do |t|
    t.bigint "question_id", null: false
    t.integer "weight", default: 0, null: false
    t.string "title", default: "", null: false
    t.boolean "acceptable", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["acceptable"], name: "index_options_on_acceptable"
    t.index ["question_id"], name: "index_options_on_question_id"
    t.index ["weight"], name: "index_options_on_weight"
  end

  create_table "profiles", force: :cascade do |t|
    t.bigint "area_id", null: false
    t.string "code", default: "", null: false
    t.string "title", default: "t", null: false
    t.boolean "careers_enabled", default: true, null: false
    t.integer "careers_requested", default: 0, null: false
    t.boolean "qualifications_enabled", default: true, null: false
    t.string "qualifications_requested", default: [], null: false, array: true
    t.string "qualifications_alternative", default: [], null: false, array: true
    t.boolean "others_enabled", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["area_id"], name: "index_profiles_on_area_id"
    t.index ["code"], name: "index_profiles_on_code"
    t.index ["title"], name: "index_profiles_on_title"
  end

  create_table "qualifications", force: :cascade do |t|
    t.bigint "request_id", null: false
    t.enum "category", default: "dsg", enum_type: "qualification_categories"
    t.string "title", default: "", null: false
    t.string "vote", default: "", null: false
    t.string "vote_type", default: "", null: false
    t.integer "year", limit: 2
    t.string "istitute", default: "", null: false
    t.string "duration", default: "", null: false
    t.string "duration_type", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_qualifications_on_category"
    t.index ["request_id"], name: "index_qualifications_on_request_id"
  end

  create_table "questions", force: :cascade do |t|
    t.bigint "section_id", null: false
    t.text "title", default: "", null: false
    t.integer "weight", default: 0, null: false
    t.enum "category", default: "string", null: false, enum_type: "question_categories"
    t.boolean "mandatory", default: false, null: false
    t.integer "max_select", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_questions_on_category"
    t.index ["mandatory"], name: "index_questions_on_mandatory"
    t.index ["section_id"], name: "index_questions_on_section_id"
    t.index ["weight"], name: "index_questions_on_weight"
  end

  create_table "requests", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "profile_id", null: false
    t.enum "status", default: "editing", null: false, enum_type: "request_statuses"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_requests_on_profile_id"
    t.index ["user_id"], name: "index_requests_on_user_id"
  end

  create_table "sections", force: :cascade do |t|
    t.bigint "profile_id", null: false
    t.string "title", default: "", null: false
    t.integer "weight", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_sections_on_profile_id"
    t.index ["weight"], name: "index_sections_on_weight"
  end

  create_table "templates", force: :cascade do |t|
    t.string "title", default: "t", null: false
    t.jsonb "data", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "index_templates_on_title"
  end

  create_table "users", force: :cascade do |t|
    t.string "tax_code", default: "", null: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "name", default: "", null: false
    t.string "surname", default: "", null: false
    t.string "email", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["surname", "name"], name: "index_users_on_surname_and_name"
    t.index ["tax_code"], name: "index_users_on_tax_code", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "additions", "requests"
  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "requests"
  add_foreign_key "areas", "contests"
  add_foreign_key "careers", "requests"
  add_foreign_key "options", "questions"
  add_foreign_key "profiles", "areas"
  add_foreign_key "qualifications", "requests"
  add_foreign_key "questions", "sections"
  add_foreign_key "requests", "profiles"
  add_foreign_key "requests", "users"
  add_foreign_key "sections", "profiles"
end
