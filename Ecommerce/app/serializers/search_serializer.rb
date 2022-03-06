# frozen_string_literal: true

class SearchSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :product_order

  def image_url1
    rails_blob_path(object.image) if object.image.attachment
  end
end
