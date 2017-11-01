class Order < ApplicationRecord
  validates :name, :address, :email, :payment_type, presence: true
  # validates :payment_type, numericality: { range: 0..2 }
  validates :email, uniqueness: true, format: {
		with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
		message: "invalid email format"
	}
end
