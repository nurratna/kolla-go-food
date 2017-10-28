class Buyer < ApplicationRecord
  validates :email, :phone, :address, presence: true
  validates :email, uniqueness: true, format: {
		with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
		message: "Email format not valid"
	}
  validates :phone, numericality: true, length: { in: 10..12 }
end
