class Supplier < ActiveRecord::Base
  validates :code, uniqueness: true, presence: true
end
