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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110622185904) do

  create_table "action_items", :force => true do |t|
    t.string   "description"
    t.integer  "question_id"
    t.integer  "import_id"
    t.string   "recurrence"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "answers", :force => true do |t|
    t.integer  "assessment_id"
    t.integer  "question_id"
    t.string   "preparedness"
    t.string   "priority"
    t.boolean  "was_skipped",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.string   "tags"
    t.string   "link"
    t.string   "document"
    t.text     "content"
    t.date     "published_on"
    t.integer  "user_id"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_public",       :default => false
  end

  create_table "assessments", :force => true do |t|
    t.integer  "organization_id"
    t.boolean  "has_performances"
    t.boolean  "has_tickets"
    t.boolean  "has_facilities"
    t.boolean  "has_programs"
    t.boolean  "has_grants"
    t.boolean  "has_exhibits"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",               :default => false
    t.boolean  "battle_buddy_enabled", :default => false
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "gmaps"
  end

  create_table "questions", :force => true do |t|
    t.string   "description"
    t.string   "critical_function"
    t.integer  "import_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resources", :force => true do |t|
    t.string   "name"
    t.string   "details"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "todos", :force => true do |t|
    t.integer  "action_item_id"
    t.integer  "answer_id"
    t.integer  "organization_id"
    t.date     "due_on"
    t.integer  "user_id"
    t.string   "details"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
    t.string   "priority"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "encrypted_password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organization_id"
    t.boolean  "admin",              :default => false
  end

end
