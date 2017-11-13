class Order < ApplicationRecord
  has_many :line_items, dependent: :destroy
  belongs_to :voucher, optional: true
  attr_accessor :code

  enum payment_type: {
    "Cash" => 0,
    "Go Pay" => 1,
    "Credit Card" => 2
  }

  validates :name, :address, :email, :payment_type, presence: true
  validates :email, format: {
		with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
		message: "invalid email format"
	}
  validates :payment_type, inclusion: payment_types.keys

  scope :grouped_by_date, -> { group("strftime('%Y-%m-%d', orders.created_at)").count }
  scope :grouped_by_total_price_per_date, -> { group("strftime('%Y-%m-%d', orders.created_at)").sum(:total_price) }

  def add_line_items(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end

  def set_total_price
    line_items.reduce(0) { |sum, line_item| sum + line_item.total_price }
  end

  def discount
    discount = 0
    if voucher.present?
      if voucher.unit == "Percent"
        discount = set_total_price * voucher.amount / 100
        discount = voucher.max_amount if discount > voucher.max_amount
      else
          discount = voucher.amount
      end
    end
    discount
  end

  def final_price
    final_price = set_total_price
    if voucher.present?
        final_price = set_total_price - discount
    end
    final_price
  end

  def self.search(name, address, email, payment_type, min_total_price, max_total_price)
    # 6 fields
    if name.present? && address.present? && email.present? && payment_type.present? && min_total_price.present? && max_total_price.present?
      where(
        "name LIKE ? AND address LIKE ? AND email LIKE ? AND payment_type LIKE ? AND total_price BETWEEN ? AND ?",
        "%#{name}%", "%#{address}%", "%#{email}%", "#{payment_type}", min_total_price.to_f, max_total_price.to_f
      ).order(:name)
    end

    # 5 fields
    if name.present? && address.present? && email.present? && payment_type.present? && min_total_price.present?
      where(
        "name LIKE ? AND address LIKE ? AND email LIKE ? AND payment_type LIKE ? AND total_price >= ?",
        "%#{name}%", "%#{address}%", "%#{email}%", "#{payment_type}", min_total_price.to_f
      ).order(:name)
    elsif name.present? && address.present? && email.present? && payment_type.present? && max_total_price.present?
      where(
        "name LIKE ? AND address LIKE ? AND email LIKE ? AND payment_type LIKE ? AND total_price <= ?",
        "%#{name}%", "%#{address}%", "%#{email}%", "#{payment_type}", max_total_price.to_f
      ).order(:name)
    elsif name.present? && address.present? && payment_type.present? && min_total_price.present? && max_total_price.present?
      where(
        "name LIKE ? AND address LIKE ? AND payment_type LIKE ? AND total_price BETWEEN ? AND ?",
        "%#{name}%", "%#{address}%", "#{payment_type}", min_total_price.to_f, max_total_price.to_f
      ).order(:name)
    elsif name.present? && address.present? && email.present? && min_total_price.present? && max_total_price.present?
      where(
        "name LIKE ? AND address LIKE ? AND email LIKE ? AND total_price BETWEEN ? AND ?",
        "%#{name}%", "%#{address}%", "#{email}", min_total_price.to_f, max_total_price.to_f
      ).order(:name)
    elsif name.present? && email.present? && payment_type.present? && min_total_price.present? && max_total_price.present?
      where(
        "name LIKE ? AND email LIKE ? AND payment_type LIKE ? AND total_price BETWEEN ? AND ?",
        "%#{name}%", "%#{email}%", "#{payment_type}", min_total_price.to_f, max_total_price.to_f
      ).order(:name)
    elsif address.present? && email.present? && payment_type.present? && min_total_price.present? && max_total_price.present?
      where(
        "address LIKE ? AND email LIKE ? AND payment_type LIKE ? AND total_price BETWEEN ? AND ?",
        "%#{address}%", "%#{email}%", "#{payment_type}", min_total_price.to_f, max_total_price.to_f
      ).order(:name)
    end

    # # 4 fields
    # if name.present? && address.present? && email.present? && payment_type.present?
    #   where(
    #     "name LIKE ? AND address LIKE ? AND email LIKE ? AND payment_type LIKE ?",
    #     "%#{name}%", "%#{address}%", "%#{email}%", "#{payment_type}"
    #   ).order(:name)
    # elsif name.present? && address.present? && email.present? && min_total_price.present?
    #   where(
    #     "name LIKE ? AND address LIKE ? AND email LIKE ? AND total_price >= ?",
    #     "%#{name}%", "%#{address}%", "%#{email}%", min_total_price.to_f
    #   ).order(:name)
    # elsif name.present? && address.present? && email.present? && max_total_price.present?
    #   where(
    #     "name LIKE ? AND address LIKE ? AND email LIKE ? AND total_price <= ?",
    #     "%#{name}%", "%#{address}%", "%#{email}%", max_total_price.to_f
    #   ).order(:name)
    # end

    # 3 fields
    if name.present? && address.present? && email.present?
      where(
        "name LIKE ? AND address LIKE ? AND email LIKE ?",
        "%#{name}%", "%#{address}%", "%#{email}%"
      ).order(:name)
    elsif name.present? && address.present? && payment_type.present?
      where(
        "name LIKE ? AND address LIKE ? AND payment_type LIKE ?",
        "%#{name}%", "%#{address}%", "#{payment_type}"
      ).order(:name)
    elsif name.present? && address.present? && min_total_price.present?
      where(
        "name LIKE ? AND address LIKE ? AND price >= ?",
        "%#{name}%", "%#{address}%", min_total_price.to_f
      ).order(:name)
    elsif name.present? && address.present? && max_total_price.present?
      where(
        "name LIKE ? AND address LIKE ? AND price <= ?",
        "%#{name}%", "%#{address}%", max_total_price.to_f
      ).order(:name)
    elsif name.present? && email.present? && payment_type.present?
      where(
        "name LIKE ? AND email LIKE ? AND payment_type LIKE ?",
        "%#{name}%", "%#{email}%", "#{payment_type}"
      ).order(:name)
    elsif name.present? && email.present? && min_total_price.present?
      where(
        "name LIKE ? AND email LIKE ? AND price >= ?",
        "%#{name}%", "%#{email}%", min_total_price.to_f
      ).order(:name)
    elsif name.present? && email.present? && max_total_price.present?
      where(
        "name LIKE ? AND email LIKE ? AND price <= ?",
        "%#{name}%", "%#{email}%", max_total_price.to_f
      ).order(:name)
    elsif name.present? && min_total_price.present? && max_total_price.present?
      where(
        "name LIKE ? AND price BETWEEN ? AND ?",
        "%#{name}%", min_total_price.to_f, max_total_price.to_f
      ).order(:name)
    elsif address.present? && email.present? && payment_type.present?
      where(
        "address LIKE ? AND email LIKE ? AND payment_type LIKE ?",
        "%#{address}%", "%#{email}%", "#{payment_type}"
      ).order(:name)
    elsif address.present? && payment_type.present? && min_total_price.present?
      where(
        "name LIKE ? AND payment_type LIKE ? AND price >= ?",
        "%#{name}%", "#{payment_type}", min_total_price.to_f
      ).order(:name)
    elsif address.present? && payment_type.present? && max_total_price.present?
      where(
        "name LIKE ? AND payment_type LIKE ? AND price <= ?",
        "%#{name}%", "#{payment_type}", max_total_price.to_f
      ).order(:name)
    elsif address.present? && min_total_price.present? && max_total_price.present?
      where(
        "address LIKE ? AND price BETWEEN ? AND ?",
        "%#{address}%", min_total_price.to_f, max_total_price.to_f
      ).order(:name)
    elsif email.present? && payment_type.present? && min_total_price.present?
      where(
        "email LIKE ? AND payment_type LIKE ? AND price >= ?",
        "%#{email}%", "#{payment_type}", min_total_price.to_f
      ).order(:name)
    elsif email.present? && payment_type.present? && min_total_price.present?
      where(
        "email LIKE ? AND payment_type LIKE ? AND price <= ?",
        "%#{email}%", "#{payment_type}", max_total_price.to_f
      ).order(:name)
    elsif email.present? && min_total_price.present? && max_total_price.present?
      where(
        "email LIKE ? AND price BETWEEN ? AND ?",
        "%#{email}%", min_total_price.to_f, max_total_price.to_f
      ).order(:name)
    elsif payment_type.present? && min_total_price.present? && max_total_price.present?
      where(
        "payment_type LIKE ? AND price BETWEEN ? AND ?",
        "#{payment_type}", min_total_price.to_f, max_total_price.to_f
      ).order(:name)
    end

    # 2 fields
    if name.present? && address.present?
      where("name LIKE ? AND address LIKE ?", "%#{name}%", "%#{address}%").order(:name)
    elsif name.present? && email.present?
      where("name LIKE ? AND email LIKE ?", "%#{name}%", "%#{email}%").order(:name)
    elsif name.present? && payment_type.present?
      where("name LIKE ? AND payment_type LIKE ?", "%#{name}%", "#{payment_type}").order(:name)
    elsif name.present? && min_total_price.present?
      where("name LIKE ? AND price >= ?", "%#{name}%", min_total_price.to_f).order(:name)
    elsif name.present? && max_total_price.present?
      where("name LIKE ? AND price <= ?", "%#{name}%", max_total_price.to_f).order(:name)
    elsif address.present? && email.present?
      where("address LIKE ? AND email LIKE ?", "%#{address}%", "%#{email}%").order(:name)
    elsif name.present? && payment_type.present?
      where("address LIKE ? AND payment_type LIKE ?", "%#{address}%", "#{payment_type}").order(:name)
    elsif address.present? && min_total_price.present?
      where("address LIKE ? AND price >= ?", "%#{address}%", min_total_price.to_f).order(:name)
    elsif address.present? && max_total_price.present?
      where("address LIKE ? AND price <= ?", "%#{address}%", max_total_price.to_f).order(:name)
    elsif email.present? && payment_type.present?
      where("email LIKE ? AND payment_type LIKE ?", "%#{email}%", "#{payment_type}").order(:name)
    elsif email.present? && min_total_price.present?
      where("email LIKE ? AND price >= ?", "%#{email}%", min_total_price.to_f).order(:name)
    elsif email.present? && max_total_price.present?
      where("email LIKE ? AND price <= ?", "%#{email}%", max_total_price.to_f).order(:name)
    elsif payment_type.present? && min_total_price.present?
      where("payment_type LIKE ? AND price >= ?", "#{payment_type}", min_total_price.to_f).order(:name)
    elsif payment_type.present? && max_total_price.present?
      where("payment_type LIKE ? AND price <= ?", "#{payment_type}", max_total_price.to_f).order(:name)
    elsif min_total_price.present? && max_total_price.present?
      where("price BETWEEN ? AND ?", min_total_price.to_f, max_total_price.to_f).order(:name)
    end

    # 1 fields
    if name.present?
      where("name LIKE ?", "%#{name}%").order(:name)
    elsif address.present?
      where("address LIKE ?", "%#{address}%").order(:name)
    elsif email.present?
      where("email LIKE ?", "%#{email}%").order(:name)
    elsif payment_type.present?
      where("payment_type LIKE ?", payment_type).order(:name)
    elsif min_total_price.present?
      where("price >= ?", min_total_price.to_f).order(:name)
    elsif max_total_price.present?
      where("price <= ?", max_total_price.to_f).order(:name)
    end
  end
end
