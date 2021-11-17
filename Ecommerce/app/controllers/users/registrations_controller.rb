class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  before_action :load_notification
  # GET /resource/sign_up
  def new
  
    super
  end
  # DELETE /resource
  def destroy
    super
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :mobile])
  end
  
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :mobile, :email, :address, :gender, :password, :avatar])
  end 

  def after_update_path_for(_resource)
    edit_user_registration_path
  end

  def update_resource(resource, params)
    resource.update(params)
  end
  def load_notification
    notifications = Notification.newest.limit(5)
    @results ={
      notifications: notifications
    }
  end
end