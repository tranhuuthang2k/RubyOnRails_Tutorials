# frozen_string_literal: true

class CommentSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :content, :product_id, :created_at, :created_at_clock, :name, :avatar, :image, :user_id
  def created_at
    object.created_at.strftime('%d/%m/%Y')
  end

  def created_at_clock
    object.created_at.strftime('%I:%M %p')
  end

  def name
    object.user.username
  end

  def avatar
    return rails_blob_path(object.user.avatar) if object.user.avatar.attachment

    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS50TvM3otu4AuOjP-R2TZ8ajlCcctHY7hxJQ&usqp=CAU'
  end

  def image
    rails_blob_path(object.image) if object.image.attachment
  end

  def user_id
    object.user.id
  end
end
