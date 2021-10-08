class Api::V1::SessionsController < Api::V1::BaseController
    def create
      user = User.find_by(email: params[:email].downcase)
      if user.present? && user.authenticate(params[:password])
        if user.activated
          log_in(user)
          user.generate_token
          set_api_token(user)
          params[:remember] == "1" ? remember(user) : forget(user)
          render json: success_message('Successfully', {user: user, api_token: user.api_token })
        else
          message = "Account not activated. Check your email for the activation link."
          render json: error_message(message)
        end
      else
        render json: error_message(t "invalid_email_password_combination")
      end
    end
  end