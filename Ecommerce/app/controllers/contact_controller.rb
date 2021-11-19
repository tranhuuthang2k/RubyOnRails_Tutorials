class ContactController < ApplicationController
  def index
    notifications = Notification.newest.limit(5)
    @results = {
      notifications: notifications
    }
  end

  def create
    @contact = Contact.new(name: params[:name], email: params[:email], subject: params[:subject],
                           message: params[:message])
    if @contact.save
      flash[:success] = 'Your Email sended success..'
      redirect_to contact_path
    else
      flash[:danger] = 'Error send mail'
      redirect_to contact_path
    end
  end
end
