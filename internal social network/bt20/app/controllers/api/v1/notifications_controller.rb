# frozen_string_literal: true

module Api
  module V1
    class NotificationsController < Api::V1::BaseController
      def index
        notifications = current_user.notifications
        render json: success_message('Successfully',
                                     ActiveModelSerializers::SerializableResource.new(notifications,
                                                                                      each_serializer: NotificationsSerializer))
      end
    end
  end
end
