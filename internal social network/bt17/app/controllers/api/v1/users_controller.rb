
class Api::V1::UsersController < Api::V1::BaseController
    def index
      users = (params[:email].present? ? User.where(email: params[:email]) : User.all).paginate(page:
        params[:page])
      render json: success_message('Successfully', users)
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
  end