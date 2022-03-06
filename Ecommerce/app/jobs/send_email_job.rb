# frozen_string_literal: true

class SendEmailJob < ApplicationJob
  queue_as :default

  def perform(user, product_order)
    # Do something later
    OrderMailer.send_order(user, product_order).deliver
  end
end
