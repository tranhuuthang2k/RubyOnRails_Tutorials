# frozen_string_literal: true

module Api
  module V1
    class CategoriesController < Api::V1::BaseController
      def index
        categories = Category.where(categories_id: params[:categories_id]).limit(4)
        render json: success_message('Successfully', categories: categories)
      end
    end
  end
end
