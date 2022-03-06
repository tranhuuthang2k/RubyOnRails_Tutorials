# frozen_string_literal: true

class BlogController < ApplicationController
  before_action :load_layout, only: %i[index blog_detail]

  def index; end

  def blog_detail
    env_http_forwarded = request.env['HTTP_X_FORWARDED_FOR']
    client_ip = if env_http_forwarded
                  env_http_forwarded.split(',').first
                else
                  request.remote_ip
                end
    id = params[:id].match(/\d+$/)[0].to_i
    post_view = ProductView.new(post_id: id, ip_post: client_ip)
    p_view = ProductView.find_by(ip_post: client_ip, post_id: id)
    post_view.save(validate: false) unless p_view
    post = Post.find(id)
    categories = Category.show_category.limit(4)
    post_other = Post.where.not(id: id).where(category_post_id: post.category_post_id).order('RANDOM()').limit(10)
    # post_other = Post.where.not(id: id).where(category_post_id: post.category_post_id).sample(10)
    brands = Brand.all
    notifications = Notification.newest.limit(5)

    @results = {
      categories: categories,
      post: post,
      post_other: post_other,
      brands: brands,
      notifications: notifications

    }
  end

  private

  def load_layout
    posts = Post.newest.page(params[:page]).per(3)
    categories = Category.show_category.limit(4)
    brands = Brand.all
    notifications = Notification.newest.limit(5)
    @results = {
      categories: categories,
      brands: brands,
      posts: posts,
      notifications: notifications
    }
  end
end
