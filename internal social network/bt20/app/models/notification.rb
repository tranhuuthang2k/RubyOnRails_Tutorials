class Notification < ApplicationRecord
    belongs_to :sender, class_name: User.name
    belongs_to :receiver, class_name: User.name
    after_commit -> { NotificationBroadcastJob.perform_later(self) }

end

