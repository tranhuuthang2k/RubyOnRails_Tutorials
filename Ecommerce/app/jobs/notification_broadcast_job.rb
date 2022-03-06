# frozen_string_literal: true

class NotificationBroadcastJob < ApplicationJob
  queue_as :default

  def perform(notification)
    # Do something later

    ActionCable.server.broadcast('notifications',
                                 { count: notification.receiver.notifications.count,
                                   receiver_id: notification.receiver_id })
  end
end
