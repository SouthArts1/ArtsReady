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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140326172342) do

  create_table "action_items", :force => true do |t|
    t.string   "description"
    t.integer  "question_id"
    t.integer  "import_id"
    t.string   "recurrence"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "deleted",     :default => false
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
    t.boolean  "featured",          :default => false
    t.boolean  "disabled",          :default => false
    t.string   "buddy_list"
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
    t.datetime "completed_at"
  end

  add_index "assessments", ["completed_at"], :name => "index_assessments_on_completed_at"
  add_index "assessments", ["organization_id"], :name => "index_assessments_on_organization_id"

  create_table "battle_buddy_requests", :force => true do |t|
    t.integer  "organization_id"
    t.integer  "battle_buddy_id"
    t.boolean  "accepted",        :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.text     "comment"
    t.integer  "user_id"
    t.integer  "article_id"
    t.boolean  "disabled",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["article_id"], :name => "index_comments_on_article_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "crises", :force => true do |t|
    t.integer  "organization_id"
    t.date     "resolved_on"
    t.text     "resolution"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "visibility"
    t.integer  "user_id"
    t.text     "description"
    t.string   "buddy_list"
  end

  add_index "crises", ["organization_id"], :name => "index_crises_on_organization_id"
  add_index "crises", ["user_id"], :name => "index_crises_on_user_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "discount_codes", :force => true do |t|
    t.string   "discount_code"
    t.integer  "deduction_value"
    t.string   "deduction_type"
    t.integer  "redemption_max"
    t.datetime "active_on"
    t.datetime "expires_on"
    t.boolean  "apply_to_first_year"
    t.boolean  "apply_to_post_first_year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
    t.integer  "recurring_deduction_value", :default => 0
    t.string   "recurring_deduction_type",  :default => "dollar"
  end

  create_table "messages", :force => true do |t|
    t.integer  "user_id"
    t.integer  "organization_id"
    t.string   "visibility"
    t.string   "recipient_list"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "needs", :force => true do |t|
    t.integer  "organization_id"
    t.integer  "crisis_id"
    t.integer  "user_id"
    t.string   "resource"
    t.text     "description"
    t.boolean  "provided",        :default => false
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
    t.boolean  "active",                     :default => false
    t.boolean  "battle_buddy_enabled",       :default => false
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "gmaps"
    t.string   "phone_number"
    t.string   "email"
    t.string   "contact_name"
    t.string   "fax_number"
    t.string   "mailing_address"
    t.string   "mailing_address_additional"
    t.string   "address_additional"
    t.string   "mailing_city"
    t.string   "mailing_state"
    t.string   "mailing_zipcode"
    t.string   "parent_organization"
    t.string   "subsidizing_organization"
    t.string   "organizational_status"
    t.string   "operating_budget"
    t.string   "ein"
    t.string   "duns"
    t.string   "nsic_code"
    t.integer  "users_count",                :default => 0
    t.string   "other_nsic_code"
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_variables", :force => true do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", :force => true do |t|
    t.integer  "organization_id"
    t.integer  "discount_code_id"
    t.integer  "starting_amount_in_cents"
    t.integer  "regular_amount_in_cents"
    t.integer  "arb_id"
    t.string   "payment_method"
    t.string   "payment_number"
    t.integer  "expiry_month"
    t.integer  "expiry_year"
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean  "active"
    t.string   "billing_first_name"
    t.string   "billing_last_name"
    t.string   "billing_address"
    t.string   "billing_city"
    t.string   "billing_state"
    t.string   "billing_zipcode"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "billing_email"
    t.string   "billing_phone_number"
  end

  create_table "questions", :force => true do |t|
    t.text     "description"
    t.string   "critical_function"
    t.integer  "import_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "deleted",           :default => false
    t.text     "help"
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

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "todo_notes", :force => true do |t|
    t.integer  "todo_id"
    t.integer  "user_id"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "article_id"
  end

  add_index "todo_notes", ["article_id"], :name => "index_todo_notes_on_article_id"
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
    t.boolean  "complete",          :default => false,     :null => false
    t.string   "status"
    t.integer  "last_user_id"
    t.string   "action",            :default => "Work On"
    t.string   "key"
  end

  add_index "todos", ["action_item_id"], :name => "index_todos_on_action_item_id"
  add_index "todos", ["answer_id"], :name => "index_todos_on_answer_id"
  add_index "todos", ["organization_id"], :name => "index_todos_on_organization_id"
  add_index "todos", ["user_id"], :name => "index_todos_on_user_id"

  create_table "updates", :force => true do |t|
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
    t.boolean  "admin",                  :default => false
    t.boolean  "disabled",               :default => false
    t.string   "role"
    t.datetime "last_login_at"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "title"
    t.string   "phone_number"
    t.boolean  "accepted_terms",         :default => true
  end

  add_index "users", ["organization_id"], :name => "index_users_on_organization_id"

end
