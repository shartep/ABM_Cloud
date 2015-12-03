class Supplier < ActiveRecord::Base
  has_many :products, foreign_key: :supplier_code, primary_key: :code

  validates :code, uniqueness: true, presence: true
end
