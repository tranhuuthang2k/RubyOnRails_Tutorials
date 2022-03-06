# frozen_string_literal: true

class OrderSerializer < ActiveModel::Serializer
  attributes :created_at, :user_id, :product_order, :status, :total_order, :id
  def created_at
    object.created_at.strftime('%d/%m/%Y')
  end
end
