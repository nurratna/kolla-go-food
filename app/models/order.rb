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

  def add_line_items(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end

  def total_price
    total_price = line_items.reduce(0) { |sum, line_item| sum + line_item.total_price }
  end

  def discount
    discount = 0
    if voucher.present?
      if voucher.unit == "Percent"
        discount = total_price * voucher.amount / 100
        discount = voucher.max_amount if discount > voucher.max_amount
      else
          discount = voucher.amount
      end
    end
    discount
  end

  def final_price
    final_price = total_price
    if voucher.present?
        final_price = total_price - discount
    end
    final_price
  end

  # def max_amount_if_bigger_than_amount
  #   if voucher.present?
  #     discount = self.discount
  #     if voucher.unit == "Percent"
  #       if
  #     end
  #   end
  # end
  #
  # end


end
