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

ActiveRecord::Schema.define(:version => 20120303055407) do

  create_table "attendances", :force => true do |t|
    t.integer   "event_id"
    t.integer   "attending_id"
    t.integer   "inviting_id"
    t.boolean   "confirmed",            :default => false
    t.boolean   "selector",             :default => true
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "votes_remaining"
    t.integer   "selections_remaining"
  end

  add_index "attendances", ["attending_id"], :name => "index_attendances_on_attending_id"
  add_index "attendances", ["event_id"], :name => "index_attendances_on_event_id"

  create_table "event_comments", :force => true do |t|
    t.integer   "user_id"
    t.integer   "event_id"
    t.string    "comment"
    t.integer   "parent_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string    "name"
    t.integer   "user_id"
    t.boolean   "public",                  :default => false
    t.date      "start"
    t.integer   "maxmovies"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "selections_per_attendee", :default => 10
    t.integer   "votes_per_attendee",      :default => 10
    t.string    "description",             :default => "No Description."
    t.date      "selections_deadline"
    t.date      "votes_deadline"
    t.boolean   "open_for_selections",     :default => true
    t.boolean   "open_for_voting",         :default => true
    t.string    "poster_file_name"
    t.string    "poster_content_type"
    t.integer   "poster_file_size"
    t.timestamp "poster_updated_at"
  end

  add_index "events", ["user_id"], :name => "index_events_on_user_id"

  create_table "movie_sessions", :force => true do |t|
    t.integer   "event_id"
    t.integer   "selection_id"
    t.timestamp "start"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "venue",        :default => "TBD"
    t.timestamp "end_at"
  end

  add_index "movie_sessions", ["event_id"], :name => "index_sessions_on_event_id"

  create_table "reviews", :force => true do |t|
    t.integer   "user_id"
    t.integer   "selection_id"
    t.integer   "rating"
    t.string    "summary"
    t.string    "review"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "selections", :force => true do |t|
    t.integer   "event_id"
    t.integer   "movie_id"
    t.string    "movie_name"
    t.integer   "user_id"
    t.integer   "votes",        :default => 0
    t.boolean   "official",     :default => false
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "poster"
    t.integer   "running_time", :default => 0
    t.integer   "position",     :default => 1
  end

  add_index "selections", ["event_id"], :name => "index_selections_on_event_id"
  add_index "selections", ["user_id"], :name => "index_selections_on_user_id"

  create_table "session_attendances", :force => true do |t|
    t.integer   "user_id"
    t.integer   "movie_session_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "",    :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "",    :null => false
    t.string   "password_salt",                         :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                                 :default => false
    t.string   "username"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "allow_notifications",                   :default => true
    t.datetime "reset_password_sent_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

  create_table "votes", :force => true do |t|
    t.integer   "selection_id"
    t.integer   "user_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

end
