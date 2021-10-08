class OrderItem < ApplicationRecord
    belongs_to :order
	belongs_to :product
	before_save :finalize

	def unit_price
		
	  if persisted?
		self[:unit_price]
	  else
		self.product.price #OrderItem.product.price
	  end
	end
  
	def total_price
	
	  unit_price * quantity  #OrderItem.unit_price * OrderItem.quantity
	end
	
	private
	
  def product_present
    if product.nil?
      errors.add(:product, "is not valid or is not active.")
    end
  end

  def order_present
    if order.nil?
      errors.add(:order, "is not a valid order.")
    end
  end

  def finalize
    self[:unit_price] = unit_price
    self[:total_price] = total_price #quantity * self[:unit_price]
  end
end
