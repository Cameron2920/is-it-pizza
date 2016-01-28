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

ActiveRecord::Schema.define(version: 20160128065223) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "questionable_pizzas", force: true do |t|
    t.integer  "is_it_pizza",              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "pizza_image_file_name"
    t.string   "pizza_image_content_type"
    t.integer  "pizza_image_file_size"
    t.datetime "pizza_image_updated_at"
    t.string   "client_ip"
  end

end