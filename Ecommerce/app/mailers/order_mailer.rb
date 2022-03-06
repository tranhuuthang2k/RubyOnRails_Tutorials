# frozen_string_literal: true

class OrderMailer < ApplicationMailer
  def send_order(user, product_order)
    @product_order = product_order
    mail(to: user.email, subject: 'Thanks for order from shop')
  end
end
