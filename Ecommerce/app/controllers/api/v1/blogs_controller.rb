# frozen_string_literal: true

module Api
  module V1
    class BlogsController < Api::V1::BaseController
      skip_before_action :require_jwt

      def search
        posts = if params[:search].present?
                  Post.where('title LIKE ?', "%#{params[:search]}%").limit(10)
                else
                  Post.newest.page(params[:page]).per(10)
                end
        render json: success_message('Successfully',
                                     { blogs: ActiveModelSerializers::SerializableResource.new(posts,
                                                                                               each_serializer: BlogSerializer) })
      end
    end
  end
end
