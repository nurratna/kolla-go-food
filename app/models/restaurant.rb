class Restaurant < ApplicationRecord
  has_many :foods
  has_many :reviews, as: :reviewable

  validates :name, :address, presence: true

  scope :grouped_by_order, -> { joins(foods: { line_items: :order }).group("restaurants.name").count }
  scope :grouped_by_total_price, -> { joins(foods: { line_items: :order }).group("restaurants.name").sum("orders.total_price") }

  def self.search(name, address, min_food_count, max_food_count)
    # if name.present? && address.present? && min_food_count.present? && max_food_count?
    #   where("name LIKE ? AND address LIKE ? AND ")
    # end

    if name.present? && address.present?
      where("name LIKE ? AND address LIKE ?", "%#{name}%", "%#{address}%")
    end

    if name.present?
      where("name LIKE ?", "%#{name}%")
    elsif address.present?
      where("address LIKE ?", "%#{address}%")
    elsif min_food_count.present?
      joins(:foods).group(:restaurant_id).having("COUNT (*) <= #{min_food_count}")
    elsif max_food_count.present?
      joins(:foods).group(:restaurant_id).having("COUNT (*) >= #{min_food_count}")
    end
  end
end
