class Voucher < ApplicationRecord
  has_many :orders
  before_save :set_upcase
  before_destroy :ensure_not_referenced_by_any_orders

  enum unit: {
    "Percent" => 0,
    "Rupiah" => 1
  }

  validates :code, :valid_from, :valid_through, :amount, :unit, :max_amount, presence: true
  validates :code, uniqueness: { case_sensitive: false }
  validates :valid_through, date: { after_or_equal_to: :valid_from }
  validates :amount, :max_amount, numericality: { greater_than_or_equal_to: 0.01 }
  validates :unit, inclusion: units.keys
  
  validates_each :max_amount do |record, attr, value|
    if record.unit == "Rupiah" && record.max_amount.present? && record.amount.present?
      record.errors.add(attr, "must be greather or equal to amount") if value < record.amount
    end
  end

  def set_upcase
    code.upcase!
  end

  def max_amount_greather_than_or_equal_amount
    if max_amount.present? && amount.present && max_amount < amount
      errors[:max_amount] << "must be greather or equal to amount"
    end
  end

  def valid_through_greather_than_or_equal_valid_from
    if valid_through.present? && valid_from.present? && valid_through < valid_from
      errors[:valid_through] << "Valid through must be greather than or equal to valid from"
    end
  end

  private
    def ensure_not_referenced_by_any_orders
      unless orders.empty?
        errors.add(:base, 'Orders present')
        throw :abort
      end
    end
end
