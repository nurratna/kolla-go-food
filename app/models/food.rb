class Food < ApplicationRecord
  has_and_belongs_to_many :tags
  belongs_to :restaurant, optional: true
  has_many :line_items
  has_many :reviews, as: :reviewable
  before_destroy :ensure_not_referenced_by_any_line_item

  validates :name, :description, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :name, uniqueness: true
  validates :image_url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png)\Z}i,
    message: 'must be a URL for GIF, JPG or PNG image'
  }

  scope :grouped_by_order, -> { joins(line_items: :order).group("foods.name").count }
  scope :grouped_by_total_price, -> { joins(line_items: :order).group("foods.name").sum("orders.total_price") }

  def self.by_letter(letter)
    where('name LIKE ?', "#{letter}%").order(:name)
  end

  def self.search(name, desc, min_price, max_price)
    if name.present? && desc.present? && min_price.present? && max_price.present?
      where(
        "name LIKE ? AND description LIKE ? AND price BETWEEN ? AND ?",
        "%#{name}%", "%#{desc}%", min_price.to_f, max_price.to_f
      ).order(:name)
    end

    if name.present? && desc.present? && min_price.present?
      where(
        "name LIKE ? AND description LIKE ? AND price >= ?",
        "%#{name}%", "%#{desc}%", min_price.to_f
      ).order(:name)
    elsif name.present? && desc.present? && max_price.present?
      where(
        "name LIKE ? AND description LIKE ? AND price <= ?",
        "%#{name}%", "%#{desc}%", max_price.to_f
      ).order(:name)
    elsif name.present? && min_price.present? && max_price.present?
      where("name LIKE ? AND price BETWEEN ? AND ?",
        "%#{name}%", min_price.to_f, max_price.to_f
      ).order(:name)
    elsif desc.present? && min_price.present? && max_price.present?
      where("description LIKE ? AND price BETWEEN ? AND ?",
        "%#{desc}%", min_price.to_f, max_price.to_f
      ).order(:name)
    end

    if name.present? && desc.present?
      where("name LIKE ? AND description LIKE ?", "%#{name}%", "%#{desc}%")
    elsif name.present? && min_price?
      where("name LIKE ? AND price >= ?", "%#{name}%", min_price.to_f).order(:name)
    elsif name.present? && max_price?
      where("name LIKE ? AND price <= ?", "%#{name}%", max_price.to_f).order(:name)
    elsif desc.present? && min_price?
      where("description LIKE ? AND price >= ?", "%#{desc}%", min_price.to_f).order(:name)
    elsif name.present? && max_price?
      where("description LIKE ? AND price <= ?", "%#{desc}%", max_price.to_f).order(:name)
    elsif min_price.present? && max_price.present?
      where("price BETWEEN ? AND ?", min_price.to_f, max_price.to_f).order(:name)
    end

    if name.present?
      where("name LIKE ? ", "%#{name}%").order(:name)
    elsif desc.present?
      where("description LIKE ? ", "%#{desc}%").order(:name)
    elsif min_price.present?
      where("price >= ? ", min_price.to_f).order(:name)
    elsif max_price.present?
      where("price <= ? ", max_price.to_f).order(:name)
    end
  end

  private
    def ensure_not_referenced_by_any_line_item
      unless line_items.empty?
        errors.add(:base, 'Line Items present')
        throw :abort
      end
    end
end
