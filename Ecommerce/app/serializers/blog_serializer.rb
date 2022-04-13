# frozen_string_literal: true

class BlogSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :title, :image_url, :content, :created_at, :username
  def image_url
    rails_blob_path(object.image) if object.image.attachment
  end

  def created_at
    object.created_at.strftime('%d/%m/%Y')
  end

  def username
    object.user&.username
  end
end
