class Product < ActiveRecord::Base
  belongs_to :supplier, foreign_key: :supplier_code, primary_key: :code

  validates :sku, uniqueness: true, presence: true
  validates :supplier_code, presence: true
end
