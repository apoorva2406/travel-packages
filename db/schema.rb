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

ActiveRecord::Schema.define(version: 20170131095950) do

  create_table "access_days", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     limit: 255
    t.text     "body",          limit: 65535
    t.string   "resource_id",   limit: 255,   null: false
    t.string   "resource_type", limit: 255,   null: false
    t.integer  "author_id",     limit: 4
    t.string   "author_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.integer  "current_sign_in_ip",     limit: 4
    t.integer  "last_sign_in_ip",        limit: 4
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "authentications", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.string   "uid",        limit: 255
    t.string   "provider",   limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "bookings", force: :cascade do |t|
    t.integer  "user_id",      limit: 4
    t.integer  "property_id",  limit: 4
    t.string   "name",         limit: 255
    t.string   "phone",        limit: 255
    t.string   "book_type",    limit: 255
    t.string   "seats",        limit: 255
    t.integer  "rooms",        limit: 4
    t.date     "start_date"
    t.date     "end_date"
    t.string   "status",       limit: 255, default: "not confirm"
    t.float    "total_amount", limit: 24
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.string   "slug",         limit: 255
  end

  create_table "facilities", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "user_id",      limit: 4
    t.integer  "property_id",  limit: 4
    t.integer  "booking_id",   limit: 4
    t.string   "mid",          limit: 255
    t.string   "order_id",     limit: 255
    t.float    "amount",       limit: 24
    t.string   "curency",      limit: 255
    t.string   "txn_id",       limit: 255
    t.string   "banktxn_id",   limit: 255
    t.string   "status",       limit: 255
    t.string   "txn_date",     limit: 255
    t.string   "gateway_name", limit: 255
    t.string   "bank_name",    limit: 255
    t.string   "payment_mode", limit: 255
    t.string   "checksum_key", limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.date     "txn_day"
    t.string   "name_on_g",    limit: 255
    t.string   "mihpayid",     limit: 255
    t.string   "email",        limit: 255
    t.string   "name_on_card", limit: 255
    t.float    "discount",     limit: 24
  end

  create_table "photos", force: :cascade do |t|
    t.integer  "imageable_id",       limit: 4
    t.string   "imageable_type",     limit: 255
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
  end

  add_index "photos", ["imageable_id", "imageable_type"], name: "index_photos_on_imageable_id_and_imageable_type", using: :btree

  create_table "properties", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "phone_number",    limit: 255
    t.string   "email",           limit: 255
    t.string   "properties_type", limit: 255
    t.integer  "no_of_seats",     limit: 4
    t.string   "contact_person",  limit: 255
    t.string   "address",         limit: 255
    t.string   "facilities",      limit: 255
    t.string   "access_day",      limit: 255
    t.string   "start_date",      limit: 255
    t.string   "end_date",        limit: 255
    t.integer  "user_id",         limit: 4
    t.float    "latitude",        limit: 24
    t.float    "longitude",       limit: 24
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.text     "description",     limit: 65535
    t.boolean  "varified",                      default: false
    t.boolean  "add_to_home",                   default: false
    t.string   "rent_status",     limit: 255
  end

  create_table "property_prices", force: :cascade do |t|
    t.integer  "seats",            limit: 4
    t.float    "price",            limit: 24
    t.integer  "property_id",      limit: 4
    t.integer  "property_type_id", limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "number_of_room",   limit: 4
    t.integer  "parent_id",        limit: 4
  end

  create_table "property_type_manages", force: :cascade do |t|
    t.integer  "property_id",      limit: 4
    t.integer  "property_type_id", limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "property_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.integer  "resource_id",   limit: 4
    t.string   "resource_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.integer  "current_sign_in_ip",     limit: 4
    t.integer  "last_sign_in_ip",        limit: 4
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "name",                   limit: 255
    t.string   "mobile_no",              limit: 255
    t.string   "profile_image",          limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "profession",             limit: 255
    t.string   "experience",             limit: 255
    t.string   "gender",                 limit: 255
    t.string   "photo_file_name",        limit: 255
    t.string   "photo_content_type",     limit: 255
    t.integer  "photo_file_size",        limit: 4
    t.datetime "photo_updated_at"
    t.string   "kyc_doc_file_name",      limit: 255
    t.string   "kyc_doc_content_type",   limit: 255
    t.integer  "kyc_doc_file_size",      limit: 4
    t.datetime "kyc_doc_updated_at"
    t.string   "otp_code",               limit: 255
    t.boolean  "verified",                           default: false
    t.boolean  "email_status",                       default: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id", limit: 4
    t.integer "role_id", limit: 4
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

end
