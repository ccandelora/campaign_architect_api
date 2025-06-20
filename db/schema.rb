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

ActiveRecord::Schema[8.0].define(version: 2025_06_13_143659) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "background_jobs", force: :cascade do |t|
    t.string "job_id"
    t.string "job_type"
    t.string "status"
    t.jsonb "result"
    t.bigint "campaign_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_background_jobs_on_campaign_id"
  end

  create_table "campaign_templates", force: :cascade do |t|
    t.string "name"
    t.string "brand"
    t.string "goal"
    t.text "description"
    t.jsonb "structure"
    t.jsonb "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "campaigns", force: :cascade do |t|
    t.string "name"
    t.string "brand"
    t.text "goal"
    t.jsonb "structure"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.jsonb "predicted_performance"
    t.jsonb "actual_performance"
    t.jsonb "settings", default: {}
    t.index ["actual_performance"], name: "index_campaigns_on_actual_performance", using: :gin
    t.index ["predicted_performance"], name: "index_campaigns_on_predicted_performance", using: :gin
    t.index ["settings"], name: "index_campaigns_on_settings", using: :gin
    t.index ["status"], name: "index_campaigns_on_status"
    t.index ["user_id"], name: "index_campaigns_on_user_id"
  end

  create_table "swipe_files", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.text "tags"
    t.string "brand"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_swipe_files_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.string "provider"
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "background_jobs", "campaigns"
  add_foreign_key "campaigns", "users"
  add_foreign_key "swipe_files", "users"
end
