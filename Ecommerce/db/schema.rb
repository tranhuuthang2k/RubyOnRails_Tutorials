# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_220_326_101_050) do
  create_table 'action_text_rich_texts', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.string 'name', null: false
    t.text 'body', size: :long
    t.string 'record_type', null: false
    t.bigint 'record_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index %w[record_type record_id name], name: 'index_action_text_rich_texts_uniqueness', unique: true
  end

  create_table 'active_storage_attachments', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'record_type', null: false
    t.bigint 'record_id', null: false
    t.bigint 'blob_id', null: false
    t.datetime 'created_at', null: false
    t.index ['blob_id'], name: 'index_active_storage_attachments_on_blob_id'
    t.index %w[record_type record_id name blob_id], name: 'index_active_storage_attachments_uniqueness',
                                                    unique: true
  end

  create_table 'active_storage_blobs', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.string 'key', null: false
    t.string 'filename', null: false
    t.string 'content_type'
    t.text 'metadata'
    t.string 'service_name', null: false
    t.bigint 'byte_size', null: false
    t.string 'checksum', null: false
    t.datetime 'created_at', null: false
    t.index ['key'], name: 'index_active_storage_blobs_on_key', unique: true
  end

  create_table 'active_storage_variant_records', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci',
                                                 force: :cascade do |t|
    t.bigint 'blob_id', null: false
    t.string 'variation_digest', null: false
    t.index %w[blob_id variation_digest], name: 'index_active_storage_variant_records_uniqueness', unique: true
  end

  create_table 'availabilities', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.string 'name'
    t.string 'status'
    t.integer 'number_instock'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.integer 'product_sold', default: 0
    t.integer 'is_ordering', default: 0
    t.integer 'number_product'
  end

  create_table 'brands', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'cart_items', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.integer 'product_id'
    t.float 'price'
    t.float 'discount'
    t.bigint 'quantily'
    t.integer 'active'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'carts', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.string 'session_id'
    t.string 'token'
    t.integer 'status'
    t.string 'username'
    t.string 'email'
    t.string 'mobile'
    t.string 'gender'
    t.string 'address'
    t.string 'city'
    t.string 'province'
    t.string 'country'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'categories', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.integer 'categories_id'
  end

  create_table 'category_brands', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.integer 'brand_id'
    t.integer 'category_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'category_posts', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.string 'name'
    t.string 'description'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'cities', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'comfy_blog_posts', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.integer 'site_id', null: false
    t.string 'title', null: false
    t.string 'slug', null: false
    t.integer 'layout_id'
    t.text 'content_cache', size: :medium
    t.integer 'year', null: false
    t.integer 'month', limit: 2, null: false
    t.boolean 'is_published', default: true, null: false
    t.datetime 'published_at', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['created_at'], name: 'index_comfy_blog_posts_on_created_at'
    t.index %w[site_id is_published], name: 'index_comfy_blog_posts_on_site_id_and_is_published'
    t.index %w[year month slug], name: 'index_comfy_blog_posts_on_year_and_month_and_slug'
  end

  create_table 'comments', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.integer 'user_id'
    t.integer 'product_id'
    t.text 'content'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.integer 'reply_comment_id'
    t.integer 'main_id'
    t.index %w[user_id product_id], name: 'index_comments_on_user_id_and_product_id'
  end

  create_table 'contacts', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.string 'name'
    t.string 'email'
    t.string 'subject'
    t.string 'message'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'keyword_searches', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.string 'key_word'
    t.integer 'count'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'notifications', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.string 'title'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'order_items', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.integer 'user_id'
    t.text 'product_order'
    t.integer 'status'
    t.float 'voucher'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.integer 'total_order'
    t.string 'service'
    t.float 'fee'
  end

  create_table 'photos', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.integer 'product_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'posts', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.string 'title'
    t.text 'content'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.integer 'user_id'
    t.integer 'category_post_id'
  end

  create_table 'product_categories', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.integer 'product_id'
    t.integer 'category_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'product_favorites', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.integer 'user_id'
    t.integer 'product_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'product_rates', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.integer 'user_id'
    t.integer 'product_id'
    t.integer 'rate'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index %w[user_id product_id], name: 'index_product_rates_on_user_id_and_product_id'
  end

  create_table 'product_sizes', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.integer 'product_id'
    t.integer 'size_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'product_views', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.integer 'product_id'
    t.string 'ip_address'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.integer 'user_id'
    t.integer 'post_id'
    t.string 'ip_post'
    t.string 'city'
  end

  create_table 'products', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.integer 'brand_id'
    t.string 'title'
    t.float 'price'
    t.text 'description'
    t.float 'price_old'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.integer 'show_home'
    t.string 'availability_id'
    t.integer 'user_id'
    t.integer 'categories_id'
    t.integer 'sold', default: 0
    t.index ['title'], name: 'index_products_on_title'
  end

  create_table 'shipping_cities', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.integer 'city_id'
    t.integer 'shipping_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'shippings', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.string 'name'
    t.string 'description'
    t.float 'price'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'sizes', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'sliders', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.string 'logoName'
    t.string 'title'
    t.string 'description'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'users', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.string 'username'
    t.string 'mobile'
    t.string 'gender'
    t.integer 'admin', default: 0
    t.string 'address'
    t.text 'profile'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.string 'provider'
    t.string 'uid'
    t.string 'api_token_digest'
    t.integer 'city_id'
  end

  create_table 'vouchers', charset: 'utf8mb4', collation: 'utf8mb4_0900_ai_ci', force: :cascade do |t|
    t.string 'code'
    t.datetime 'expire'
    t.float 'cost'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  add_foreign_key 'active_storage_attachments', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'active_storage_variant_records', 'active_storage_blobs', column: 'blob_id'
end
