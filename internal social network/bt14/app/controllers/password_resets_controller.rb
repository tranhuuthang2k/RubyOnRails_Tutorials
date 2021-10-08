class PasswordResetsController < ApplicationController
  skip_before_action :sign_in
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def edit
  end

  def update
    @user.password = user_params[:password]
    @user.password_confirmation = user_params[:password_confirmation]
    if @user.save
     flash[:info] ="change password success"
     redirect_to login_path    
    else
     render :edit
    end
  end

  def create
    # @user = User.find_by email: params[:email].downcase
    @user= User.find_by email: params[:password_reset][:email]
    if @user
      @user.create_token_digest_rspw
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to login_path
    else
      flash.now[:danger] = "Email address not found"
      render :new
    end
  end

  private
  
  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def get_user
   @user = User.find_by email: params[:email]
  end

  def valid_user
   return if (@user && @user.activated && @user.authenticated?(:reset, params[:id]))
   redirect_to login_path
  end
  
  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = "Password reset has expired."
    redirect_to new_password_reset_url
  end
end
