class Product < ActiveRecord::Base
  has_many :orders

  def stock_quantity
    9
  end
end
