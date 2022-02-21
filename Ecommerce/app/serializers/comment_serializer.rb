class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :product_id, :created_at, :created_at_clock

  def created_at
    object.created_at.strftime("%d/%m/%Y")
  end

  def created_at_clock
    object.created_at.strftime("%I:%M %p")
  end
end
