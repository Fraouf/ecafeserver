# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090725175919) do

  create_table "bdrb_job_queues", :force => true do |t|
    t.text     "args"
    t.string   "worker_name"
    t.string   "worker_method"
    t.string   "job_key"
    t.integer  "taken"
    t.integer  "finished"
    t.integer  "timeout"
    t.integer  "priority"
    t.datetime "submitted_at"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "archived_at"
    t.string   "tag"
    t.string   "submitter_info"
    t.string   "runner_info"
    t.string   "worker_key"
    t.datetime "scheduled_at"
  end

  create_table "clients", :id => false, :force => true do |t|
    t.string   "ip_address",   :limit => 40
    t.integer  "port"
    t.string   "hostname"
    t.string   "session_id",   :limit => 36
    t.string   "state"
    t.integer  "timecode_id"
    t.integer  "customer_id"
    t.datetime "last_request"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clients", ["ip_address"], :name => "index_clients_on_ip_address", :unique => true

  create_table "configurations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "credits", :force => true do |t|
    t.integer  "amount"
    t.integer  "timecode_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", :force => true do |t|
    t.string   "name",             :limit => 100, :default => ""
    t.string   "login",            :limit => 40
    t.string   "crypted_password", :limit => 40
    t.string   "salt",             :limit => 40
    t.string   "email",            :limit => 100
    t.string   "phone",            :limit => 100
    t.text     "question"
    t.text     "answer"
    t.datetime "last_login_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "customers", ["login"], :name => "index_customers_on_login", :unique => true

  create_table "employees", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.boolean  "is_admin"
  end

  add_index "employees", ["login"], :name => "index_employees_on_login", :unique => true

  create_table "models", :force => true do |t|
    t.string   "title"
    t.integer  "price"
    t.integer  "expiration"
    t.integer  "time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "operations", :force => true do |t|
    t.string   "user"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "timecodes", :force => true do |t|
    t.integer  "price"
    t.datetime "expiration"
    t.boolean  "expires"
    t.integer  "time"
    t.boolean  "unlimited"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "customer_id"
  end

end
