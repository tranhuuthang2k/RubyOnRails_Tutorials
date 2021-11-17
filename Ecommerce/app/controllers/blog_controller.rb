class BlogController < ApplicationController
  before_action :load_layout, only: %i[index blog_detail]

  def index; end

  def blog_detail
    id = params[:id].match(/\d+$/)[0].to_i
    post = Post.find(id)
    categories = Category.show_category.limit(4)
    post_other = Post.where.not(id: id).where(category_post_id: post.category_post_id).limit(3)
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
