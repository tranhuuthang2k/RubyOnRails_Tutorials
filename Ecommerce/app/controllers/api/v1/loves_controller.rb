# frozen_string_literal: true

module Api
  module V1
    class LovesController < Api::V1::BaseController
      skip_before_action :require_jwt
      before_action :load_user,
                    only: %i[index unlove comment reply_comment rate edit_comment_children edit_comment delete_comment
                             delete_comment_children]
      before_action :load_comment, only: %i[edit_comment_children edit_comment]
      def index
        product_favorite = @user.product_favorites.new(user_id: @user.id, product_id: params[:product_id])
        if product_favorite.save
          render json: success_message('Successfully',
                                       { product_favorite: ActiveModelSerializers::SerializableResource.new(product_favorite,
                                                                                                            each_serializer: LoveSerializer) })
        else
          render json: error_message(t('product id not_found'))
        end
      end

      def unlove
        product_favorite = @user.product_favorites.find_by(product_id: params[:product_id])
        if product_favorite
          product_favorite.delete
          render json: success_message('Successfully',
                                       { product_favorite: ActiveModelSerializers::SerializableResource.new(product_favorite,
                                                                                                            each_serializer: LoveSerializer) })
        else
          render json: error_message(t('product id not_found'))
        end
      end

      def comment
        unless params[:content].present? && params[:content].present? && params[:product_id]
          return render json: error_message('Please write your content')
        end

        comment = @user.comments.new(content: params[:content], product_id: params[:product_id], user_id: @user.id)
        comment.image.attach(params['csv'])
        name = @user.username
        if comment.save

          comment.update_attribute(:main_id, comment.id)
          render json: success_message('Successfully',
                                       { name: name,
                                         image: comment.image.present? ? url_for(comment.image) : '',
                                         avatar: @user.avatar.present? ? url_for(@user.avatar) : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS50TvM3otu4AuOjP-R2TZ8ajlCcctHY7hxJQ&usqp=CAU',
                                         comment: ActiveModelSerializers::SerializableResource.new(comment,
                                                                                                   each_serializer: CommentSerializer) })
        end
      end

      def reply_comment
        return render json: error_message('Write your comment...') unless params[:content].present?

        comment = Comment.find(params[:id_comment])
        product_id = comment.product_id
        parrent_comment_id = comment.id
        reply_comment = @user.comments.new(content: params[:content], reply_comment_id: parrent_comment_id,
                                           product_id: product_id, user_id: @user.id)

        if reply_comment.save

          render json: success_message('Successfully',
                                       { name: @user.username,
                                         avatar: @user.avatar.present? ? url_for(@user.avatar) : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS50TvM3otu4AuOjP-R2TZ8ajlCcctHY7hxJQ&usqp=CAU',
                                         comment: ActiveModelSerializers::SerializableResource.new(reply_comment,
                                                                                                   each_serializer: CommentSerializer) })

        else
          render json: error_message(('product id not_found'))
        end
      end

      def edit_comment
        @comment.content = params[:comment]
        if @comment.save
          render json: success_message('Successfully',
                                       {
                                         name: @user.username,
                                         avatar: @user.avatar.present? ? url_for(@user.avatar) : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS50TvM3otu4AuOjP-R2TZ8ajlCcctHY7hxJQ&usqp=CAU',
                                         comment: ActiveModelSerializers::SerializableResource.new(@comment,
                                                                                                   each_serializer: CommentSerializer)
                                       })
        else
          render json: error_message(('comment id not_found'))
        end
      end

      def edit_comment_children
        edit_comment
      end

      def delete_comment_children
        comment = Comment.find(params[:comment_id])
        return render json: error_message('comment not exists') if comment.user_id != @user.id

        if comment
          comment.delete
          render json: success_message('Successfully')
        else
          render json: error_message('comment id not_found')
        end
      end

      def delete_comment
        comment = Comment.find(params[:comment_id])
        return render json: error_message('comment not exists') if comment.user_id != @user.id

        comment.image.purge if comment.image.attached?

        if comment.present?
          comment.delete
          comment.comment_childrens.delete_all
          render json: success_message('Successfully')
        else
          render json: error_message('comment id not_found')
        end
      end

      def more_comment
        product_id = params[:product_id].match(/\d+$/)[0].to_i
        comment_user = Comment.includes(:user)
        comment_users = comment_user.where(product_id: product_id).where(main_id: comment_user.pluck('main_id').compact)
        comments = comment_users.page(params[:page]).per(3)
        page_next = params[:page].to_i + 1
        show_btn_load = comment_users.page(page_next).per(3)

        data = []
        comments.each do |comment|
          data << {
            'comment_parent' => ActiveModelSerializers::SerializableResource.new(comment,
                                                                                 each_serializer: CommentSerializer),
            'comment_childrens' => ActiveModelSerializers::SerializableResource.new(comment.comment_childrens,
                                                                                    each_serializer: CommentSerializer)
          }
        end
        render json: success_message('Successfully',
                                     { data: data, 'show_btn_load' => show_btn_load.size.positive? ? true : false })
      end

      def rate
        data = []
        data << @user.order_items.this_status(OrderItem::STOCK[:Instock]).pluck('product_order').map do |x|
          JSON.parse(x)
        end
        if @user.order_items.present? && data.flatten.pluck('id').include?(params[:product_id])
          rate = @user.product_rates.new(rate: params[:rate], product_id: params[:product_id], user_id: @user.id)
          product_rates = ProductRate.where(product_id: params[:product_id]).to_a
          sum_rate = product_rates.sum(&:rate)
          count_product = product_rates.size
          avg = count_product.zero? ? params[:rate] : sum_rate / count_product
          if rate.save
            render json: success_message('Successfully',
                                         { avg: avg,
                                           rate: ActiveModelSerializers::SerializableResource.new(rate,
                                                                                                  each_serializer: RateSerializer) })
          end
        else
          render json: error_message('Error message')
          # render :json => { :success => false, :message=> I18n.t('not_purchased') }, :status => 401
        end
      end

      private

      def load_user
        token = params[:token]
        hmac_secret = 'rubyk01'
        decoded_token = JWT.decode token, hmac_secret, true, { algorithm: 'HS256' }

        @user = User.find_by(api_token_digest: decoded_token.first['data'])
      end

      def load_comment
        return render json: error_message('Please write your content') unless params[:comment].present?

        @comment = Comment.find_by(id: params[:comment_id])
        if @comment.user_id != @user.id
          render json: error_message('you are not the author of this comment')
        else
          @comment
        end
      end
    end
  end
end
