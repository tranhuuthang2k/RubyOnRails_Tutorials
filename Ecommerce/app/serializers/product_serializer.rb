# frozen_string_literal: true

class ProductSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :title, :price, :id, :image, :image_url1, :product_sold, :stock
  def image_url1
    rails_blob_path(object.image) if object.image.attachment
  end

  def product_sold
    (object.availability&.product_sold.positive? ? object.availability&.product_sold : nil)
  end

  def stock
    object.availability.status.to_i == OrderItem::STOCK[:Instock].to_i ? 'Instock' : nil
  end
end
