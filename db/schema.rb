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

ActiveRecord::Schema[7.0].define(version: 2022_07_20_134655) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "areas", "contests"
  add_foreign_key "profiles", "areas"
end
