
class Api::V1::UsersController < Api::V1::BaseController
    def index
      users = (params[:email].present? ? User.where(email: params[:email]) : User.all).paginate(page:
        params[:page])
      render json: success_message('Successfully', users)
    end

    def comment
      comment = current_user.comments.new(content: params[:comment], micropost_id: params[:post_id])
      if comment.save
        render json: success_message('Successfully', { avatar: gravatar_for_user, comment: comment })  
        else
        render json: error_message(t "micropost.not_found")
      end
    end

    def friends
      users = User.where.not(id: current_user.id).paginate(page: params[:page], per_page: 5)
      total_pages = users.total_pages
      next_page = params[:page].to_i + 1
      render json: success_message('Successfully', {users: users,
                                                    total_pages: total_pages,
                                                    next_page: next_page
                                                   })
    end
    
    def follows
      user = User.find(params['id'])
      current_user.follow(user)
      following_id = current_user.following.pluck(:id)
      following_id << current_user.id
      users = User.where.not(id: following_id).paginate(page: 1, per_page: 5)
      total_pages = users.total_pages
      next_page = params[:page].to_i + 1
      render json: success_message('Successfully', {users: users,
                                                    total_pages: total_pages,
                                                    next_page: next_page,
                                                    user: user
                                                   })
    end
    
    private

    def gravatar_for_user(options = {size: 40})
      gravatar_id = Digest::MD5::hexdigest(current_user.email.downcase)
      size = options[:size]
      "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    end
  end