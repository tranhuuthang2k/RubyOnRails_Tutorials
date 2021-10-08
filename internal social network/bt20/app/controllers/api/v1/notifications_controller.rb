class Api::V1::NotificationsController < Api::V1::BaseController
    def index
        notifications = current_user.notifications
        render json: success_message('Successfully', ActiveModelSerializers::SerializableResource.new(notifications, each_serializer: NotificationsSerializer))
    end
end