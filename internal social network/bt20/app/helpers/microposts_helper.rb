module MicropostsHelper
    def author_of_micropost? userId
      user = User.find_by(id: userId )
      @user  = user
    end
end
