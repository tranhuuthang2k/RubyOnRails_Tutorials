# frozen_string_literal: true

module CommentsHelper
  def current_comment_mircopost
    @comment.micropost.user
  end
end
