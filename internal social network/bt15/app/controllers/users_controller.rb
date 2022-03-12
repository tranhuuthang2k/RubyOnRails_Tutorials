# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :sign_in, only: %i[show index create]
  skip_before_action :redirect_to_users
  before_action :set_user, only: %i[show edit update destroy]
  before_action :correct_user, only: [:update]

  # GET /users or /users.json
  def index
    @email = params[:email]
    @users = (@email.present? ? User.where(email: @email) : User.all).paginate(page: params[:page])
  end

  # GET /users/1 or /users/1.json
  def show
    @microposts = @user.microposts
  end

  # GET /users/new
  def new
    @user ||= User.new
  end

  # GET /users/1/edit
  def edit
    unless current_user.admin || current_user?(@user)
      flash[:danger] = t 'You must be admin or this user'
      redirect_to users_path
    end
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = 'Please check your email to activate your account.'
      redirect_to login_path
    else
      render :new
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        flash[:success] = t 'User was successfully updated'
        format.html { redirect_to @user }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      flash[:success] = t 'User was successfully destroyed'
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :email, :phone, :age, :date_of_birth, :gender, :password,
                                 :password_confirmation)
  end

  def correct_user
    @user = User.find_by(id: params[:id])
    redirect_to(root_url) unless @user == current_user || current_user&.admin
  end
end
