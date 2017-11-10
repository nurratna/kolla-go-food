class Restaurant < ApplicationRecord
  has_many :foods
  has_many :reviews, as: :reviewable

  validates :name, :address, presence: true
end
