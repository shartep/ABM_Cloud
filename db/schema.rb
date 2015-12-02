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

ActiveRecord::Schema.define(version: 20151202171357) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "products", force: :cascade do |t|
    t.string   "sku",                         null: false
    t.string   "supplier_code",               null: false
    t.text     "field_1"
    t.text     "field_2"
    t.text     "field_3"
    t.text     "field_4"
    t.text     "field_5"
    t.text     "field_6"
    t.decimal  "price",         precision: 2
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "products", ["sku"], name: "index_products_on_sku", using: :btree
  add_index "products", ["supplier_code"], name: "index_products_on_supplier_code", using: :btree

  create_table "project_files", force: :cascade do |t|
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "file_type"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "suppliers", force: :cascade do |t|
    t.string   "code",       null: false
    t.text     "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "suppliers", ["code"], name: "index_suppliers_on_code", using: :btree

end
