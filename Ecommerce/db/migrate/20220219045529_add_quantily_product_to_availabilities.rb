class AddQuantilyProductToAvailabilities < ActiveRecord::Migration[6.1]
  def change
    add_column :availabilities, :quantily_product, :integer
  end
end
