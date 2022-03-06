# frozen_string_literal: true

class ProductSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :title, :price, :id, :image, :image_url1
  def image_url1
    rails_blob_path(object.image) if object.image.attachment
  end
end
