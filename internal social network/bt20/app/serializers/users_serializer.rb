# frozen_string_literal: true

class UsersSerializer < ActiveModel::Serializer
  attributes :id, :name, :avatar

  def avatar
    gravatar_id = Digest::MD5.hexdigest(object.email.downcase)
    "https://secure.gravatar.com/avatar/#{gravatar_id}?s=80"
  end
end
