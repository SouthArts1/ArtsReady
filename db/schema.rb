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

ActiveRecord::Schema.define(:version => 20110726194815) do

  create_table "action_items", :force => true do |t|
    t.string   "description"
    t.integer  "question_id"
    t.integer  "import_id"
    t.string   "recurrence"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "action_items", ["import_id"], :name => "index_action_items_on_import_id"
  add_index "action_items", ["question_id"], :name => "index_action_items_on_question_id"

  create_table "answers", :force => true do |t|
    t.integer  "assessment_id"
    t.integer  "question_id"
    t.string   "preparedness"
    t.string   "priority"
    t.boolean  "was_skipped"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "critical_function"
  end

  add_index "answers", ["assessment_id"], :name => "index_answers_on_assessment_id"
  add_index "answers", ["critical_function"], :name => "index_answers_on_critical_function"
  add_index "answers", ["question_id"], :name => "index_answers_on_question_id"

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.string   "link"
    t.string   "document"
    t.text     "body"
    t.date     "published_on"
    t.integer  "user_id"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
    t.string   "visibility",        :default => "private"
    t.string   "critical_function"
    t.boolean  "on_critical_list",  :default => false
    t.integer  "todo_id"
  end

  add_index "articles", ["organization_id"], :name => "index_articles_on_organization_id"
  add_index "articles", ["user_id"], :name => "index_articles_on_user_id"

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
    t.boolean  "complete",                :default => false
    t.integer  "answers_count",           :default => 0
    t.integer  "completed_answers_count", :default => 0
  end

  add_index "assessments", ["organization_id"], :name => "index_assessments_on_organization_id"

  create_table "crises", :force => true do |t|
    t.integer  "organization_id"
    t.string   "name"
    t.text     "description"
    t.boolean  "declared_on"
    t.date     "resolved_on"
    t.text     "resolution"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "crises", ["organization_id"], :name => "index_crises_on_organization_id"

  create_table "needs", :force => true do |t|
    t.integer  "organization_id"
    t.integer  "crisis_id"
    t.integer  "user_id"
    t.string   "resource"
    t.text     "description"
    t.boolean  "provided"
    t.string   "provider"
    t.date     "last_updated_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "needs", ["crisis_id"], :name => "index_needs_on_crisis_id"
  add_index "needs", ["organization_id"], :name => "index_needs_on_organization_id"
  add_index "needs", ["user_id"], :name => "index_needs_on_user_id"

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
    t.text     "description"
    t.string   "critical_function"
    t.integer  "import_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["import_id"], :name => "index_questions_on_import_id"

  create_table "resources", :force => true do |t|
    t.string   "name"
    t.string   "details"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "resources", ["organization_id"], :name => "index_resources_on_organization_id"

  create_table "todo_notes", :force => true do |t|
    t.integer  "todo_id"
    t.integer  "user_id"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "todo_notes", ["todo_id"], :name => "index_todo_notes_on_todo_id"
  add_index "todo_notes", ["user_id"], :name => "index_todo_notes_on_user_id"

  create_table "todos", :force => true do |t|
    t.integer  "action_item_id"
    t.integer  "answer_id"
    t.integer  "organization_id"
    t.date     "due_on"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
    t.string   "priority"
    t.date     "review_on"
    t.string   "critical_function"
    t.boolean  "complete",          :default => false, :null => false
    t.string   "status"
  end

  add_index "todos", ["action_item_id"], :name => "index_todos_on_action_item_id"
  add_index "todos", ["answer_id"], :name => "index_todos_on_answer_id"
  add_index "todos", ["organization_id"], :name => "index_todos_on_organization_id"
  add_index "todos", ["user_id"], :name => "index_todos_on_user_id"

  create_table "updates", :force => true do |t|
    t.string   "title"
    t.text     "message"
    t.integer  "user_id"
    t.integer  "crisis_id"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "updates", ["crisis_id"], :name => "index_updates_on_crisis_id"
  add_index "updates", ["organization_id"], :name => "index_updates_on_organization_id"
  add_index "updates", ["user_id"], :name => "index_updates_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "encrypted_password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organization_id"
    t.boolean  "admin",              :default => false
    t.boolean  "active",             :default => false
    t.string   "role"
    t.datetime "last_login_at"
  end

  add_index "users", ["organization_id"], :name => "index_users_on_organization_id"

end
