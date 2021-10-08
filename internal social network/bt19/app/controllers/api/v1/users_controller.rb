
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
      following_id = current_user.following.pluck(:id)
      following_id << current_user.id
      users = User.where.not(id: following_id).paginate(page: params[:page], per_page: 2)
      total_pages = users.total_pages
      next_page = params[:page].to_i + 1
      render json: success_message('Successfully', {users: ActiveModelSerializers::SerializableResource.new(users, each_serializer: UsersSerializer),
                                                    total_pages: total_pages,
                                                    next_page: next_page
                                                   })
    end
    
    def follows
      user = User.find(params['id'])
      current_user.follow(user)
      message = current_user.name + " following you"
      begin
        Notification.create(sender_id: current_user.id, receiver_id: user.id, content: message)
      rescue => e
        logger = Logger.new("log/abc.log")
        logger.info "#{e.backtrace}"
      end
      following_id = current_user.following.pluck(:id)
      following_id << current_user.id
      users = User.where.not(id: following_id).paginate(page: 1, per_page: 2)
      total_pages = users.total_pages
      next_page = params[:page].to_i + 1
      
      render json: success_message('Successfully', {users: ActiveModelSerializers::SerializableResource.new(users, each_serializer: UsersSerializer),
                                                    total_pages: total_pages,
                                                    next_page: next_page
                                                   })
    end
    
    private

    def gravatar_for_user(options = {size: 40})
      gravatar_id = Digest::MD5::hexdigest(current_user.email.downcase)
      size = options[:size]
      "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    end
  end