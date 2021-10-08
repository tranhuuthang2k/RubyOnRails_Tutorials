module CommentsHelper
    def current_comment_mircopost
        @comment.micropost.user
    end
end
