# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_07_04_052702) do

  create_table "products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "uuid"
    t.string "image"
    t.string "name"
    t.string "category"
    t.float "actual_price"
    t.float "regular_price"
    t.float "discount"
    t.string "description"
    t.string "restaurant"
    t.float "average_rating"
    t.integer "total_ratings", default: 0
    t.integer "min_estimative"
    t.integer "max_estimative"
    t.string "city"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
  end

  create_table "transactions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "uuid"
    t.integer "order_id"
    t.float "amount"
    t.integer "transaction_type"
    t.integer "account_type"
    t.string "from_CPF"
    t.string "to_CPF"
    t.boolean "scheduled"
    t.integer "timestamp"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
  end

  create_table "user_addresses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "street"
    t.string "number"
    t.string "description"
    t.string "CEP"
    t.string "city"
    t.string "uf"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.string "nickname"
    t.integer "user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "uuid"
    t.string "email"
    t.string "password_digest"
    t.string "CPF"
    t.string "name"
    t.string "phone_number"
    t.float "regular_balance"
    t.float "meal_allowance_balance"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.string "authentication_token"
    t.integer "expired_ts"
  end

end
