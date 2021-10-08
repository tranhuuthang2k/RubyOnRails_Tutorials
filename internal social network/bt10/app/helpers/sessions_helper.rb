module SessionsHelper
    def log_in user
        session[:user_id] = user.id
    end

    def current_user
        @current_user ||= User.find_by(id: session[:user_id])
    end

    def logged_in?
        current_user.present?
        
    end

    def log_out
        session.delete(:user_id)
        @current_user= nil
    end
    def sign_in
        return if logged_in?
        redirect_to login_path
    end
    def redirect_to_users
        if logged_in?
            return redirect_to users_path
        end
    end
end
