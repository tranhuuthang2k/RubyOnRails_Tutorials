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
    post_view = ProductView.new(post_id: id, ip_post: client_ip, city: request.location.city)
    p_view = ProductView.find_by(ip_post: client_ip, post_id: id)
    post_view.save(validate: false) unless p_view
    post = Post.find(id)
    # post_other = Post.where.not(id: id).where(category_post_id: post.category_post_id).order('RANDOM()').limit(10)
    post_other = Post.where.not(id: id).where(category_post_id: post.category_post_id).sample(10)

    @results = {
      post: post,
      post_other: post_other,
      notifications: @results[:notifications],
      categoies_post: @results[:categoies_post],
      best_view_post: @results[:best_view_post]
    }
  end

  def blog_category
    id = params[:id].match(/\d+$/)[0].to_i
    list_post = Post.where(category_post_id: id).newest.page(params[:page]).per(10)

    @results = {
      list_post: list_post,
      notifications: load_notification
    }
  end

  private

  def load_layout
    posts = Post.newest.page(params[:page]).per(10)
    categoies_post = CategoryPost.all
    product_views = ProductView.select(:post_id).where.not(post_id: nil).group(:post_id).order('post_id DESC')
    post_ids = product_views.size.values.sort.reverse.take(10).map { |item| product_views.size.key(item) }
    best_view_post = product_views.where(post_id: post_ids)
    @results = {
      categoies_post: categoies_post,
      posts: posts,
      notifications: load_notification,
      best_view_post: best_view_post
    }
  end

  def load_notification
    @notifications = Notification.newest.limit(5)
  end
end
