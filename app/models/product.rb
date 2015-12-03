class Product < ActiveRecord::Base
  validates :sku, uniqueness: true, presence: true
  validates :supplier_code, presence: true
end
