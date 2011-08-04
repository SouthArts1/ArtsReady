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

ActiveRecord::Schema.define(:version => 20110804215409) do

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
    t.boolean  "featured",          :default => false
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

  create_table "cms_blocks", :force => true do |t|
    t.integer  "page_id"
    t.string   "label"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cms_blocks", ["page_id", "label"], :name => "index_cms_blocks_on_page_id_and_label"

  create_table "cms_layouts", :force => true do |t|
    t.integer  "site_id"
    t.integer  "parent_id"
    t.string   "app_layout"
    t.string   "label"
    t.string   "slug"
    t.text     "content"
    t.text     "css"
    t.text     "js"
    t.integer  "position",   :default => 0,     :null => false
    t.boolean  "is_shared",  :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cms_layouts", ["parent_id", "position"], :name => "index_cms_layouts_on_parent_id_and_position"
  add_index "cms_layouts", ["site_id", "slug"], :name => "index_cms_layouts_on_site_id_and_slug", :unique => true

  create_table "cms_pages", :force => true do |t|
    t.integer  "site_id"
    t.integer  "layout_id"
    t.integer  "parent_id"
    t.integer  "target_page_id"
    t.string   "label"
    t.string   "slug"
    t.string   "full_path"
    t.text     "content"
    t.integer  "position",       :default => 0,     :null => false
    t.integer  "children_count", :default => 0,     :null => false
    t.boolean  "is_published",   :default => true,  :null => false
    t.boolean  "is_shared",      :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cms_pages", ["parent_id", "position"], :name => "index_cms_pages_on_parent_id_and_position"
  add_index "cms_pages", ["site_id", "full_path"], :name => "index_cms_pages_on_site_id_and_full_path"

  create_table "cms_revisions", :force => true do |t|
    t.string   "record_type"
    t.integer  "record_id"
    t.text     "data"
    t.datetime "created_at"
  end

  add_index "cms_revisions", ["record_type", "record_id", "created_at"], :name => "index_cms_revisions_on_record_type_and_record_id_and_created_at"

  create_table "cms_sites", :force => true do |t|
    t.string  "label"
    t.string  "hostname"
    t.string  "path"
    t.string  "locale",      :default => "en",  :null => false
    t.boolean "is_mirrored", :default => false, :null => false
  end

  add_index "cms_sites", ["hostname"], :name => "index_cms_sites_on_hostname"
  add_index "cms_sites", ["is_mirrored"], :name => "index_cms_sites_on_is_mirrored"

  create_table "cms_snippets", :force => true do |t|
    t.integer  "site_id"
    t.string   "label"
    t.string   "slug"
    t.text     "content"
    t.boolean  "is_shared",  :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cms_snippets", ["site_id", "slug"], :name => "index_cms_snippets_on_site_id_and_slug", :unique => true

  create_table "cms_uploads", :force => true do |t|
    t.integer  "site_id"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cms_uploads", ["site_id", "file_file_name"], :name => "index_cms_uploads_on_site_id_and_file_file_name"

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
    t.boolean  "admin",                  :default => false
    t.boolean  "disabled",               :default => false
    t.string   "role"
    t.datetime "last_login_at"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
  end

  add_index "users", ["organization_id"], :name => "index_users_on_organization_id"

end
