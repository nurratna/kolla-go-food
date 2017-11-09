class Restaurant < ApplicationRecord
  has_many :foods

  validates :name, :address, presence: true
end
