class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :product_id, :created_at, :created_at_clock, :avatar
  def created_at
    object.created_at.strftime("%d/%m/%Y")
  end

  def created_at_clock
    object.created_at.strftime("%I:%M %p")
  end

  def avatar
    "/assets/home/iframe2.png"
  end
end
