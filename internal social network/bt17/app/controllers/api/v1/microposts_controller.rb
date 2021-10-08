class Api::V1::MicropostsController < Api::V1::BaseController
    def comment
      comment = current_user.comments.new(content: params[:comment], micropost_id: params[:post_id])
      if comment.save
        render json: success_message('Successfully', { avatar: gravatar_for_user, comment: comment })  
        else
        render json: error_message(t "micropost.not_found")
      end
    end
  private

    def gravatar_for_user(options = {size: 40})
      gravatar_id = Digest::MD5::hexdigest(current_user.email.downcase)
      size = options[:size]
      "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    end
end