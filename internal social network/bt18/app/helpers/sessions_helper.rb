module SessionsHelper
    def log_in user
        session[:user_id] = user.id
    end

    def current_user
        if session[:user_id]
            @current_user ||= User.find_by(id: session[:user_id])
        elsif  cookies.signed[:user_id]
            user = User.find_by(id: cookies.signed[:user_id] )
            if user.present? && user.authenticated?(:remember,cookies[:remember_token])
                log_in user
                @current_user = user
            end
        end  
    end


    def current_user?(user)
        user == current_user
    end

    def logged_in?
        current_user.present?
        
    end

    def forget(user)
        user.forget
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
    end

    def log_out
        forget(current_user)
        current_user.update_attribute(:api_token_digest, nil)
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

  
    def remember user
        user.remember #create token random & save db
        cookies.permanent.signed[:user_id] = user.id #set cookie user_id to brower
        cookies.permanent[:remember_token] = user.remember_token #set cookie rememer_token to brower
    end

    def set_api_token(user)
        cookies.permanent[:api_token] = user.try(:api_token) || ''
    end

end
