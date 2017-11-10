class Review < ApplicationRecord
  belongs_to :reviewable, polymorphic: true

  validates :name, :title, :description, presence: true
  validates :name, uniqueness: true
end
