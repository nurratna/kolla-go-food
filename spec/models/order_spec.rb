require 'rails_helper'

describe Order do
  it 'has a valid factory' do
    expect(build(:order)).to be_valid
  end

  it 'is a valid with name, address, eamil, and payment_type' do
    expect(build(:order)).to be_valid
  end

  it 'is invalid without name' do
    order = build(:order, name:nil)
    order.valid?
    expect(order.errors[:name]).to include("can't be blank")
  end

  it 'is invalid without an address' do
    order = build(:order, address:nil)
    order.valid?
    expect(order.errors[:address]).to include("can't be blank")
  end

  it 'is invalid without email' do
    order = build(:order, email:nil)
    order.valid?
    expect(order.errors[:email]).to include("can't be blank")
  end

  it 'is invalid with email not in valid email format' do
    order = build(:order, email: 'email')
    order.valid?
    expect(order.errors[:email]).to include("invalid email format")
  end

  it 'is invalid without payment_type' do
    order = build(:order, payment_type:nil)
    order.valid?
    expect(order.errors[:payment_type]).to include("can't be blank")
  end

  it 'is invalid with wrong payment_type' do
    expect{
      build(:order, payment_type: 'grab pay')
    }.to raise_error(ArgumentError)
  end

  describe 'adding line_items from cart' do
    before :each do
      @cart = create(:cart)
      @line_item = create(:line_item, cart: @cart)
      @order = build(:order)
    end

    it 'add line_items to order' do
      expect {
        @order.add_line_items(@cart)
        @order.save
      }.to change(@order.line_items, :count).by(1)
    end

    it 'removes line_items from cart' do
      expect {
        @order.add_line_items(@cart)
        @order.save
      }.to change(@cart.line_items, :count).by(-1)
    end
  end

  describe 'adding voucher to order' do
    context "with valid voucher" do
      before :each do
        @voucher = create(:voucher, code: "PROMO", amount: 15.0, unit: "Percent", max_amount: 2500.0)
        @cart = create(:cart)
        @food = create(:food, price: 10000.0)
        @line_item = create(:line_item, quantity: 2, food: @food, cart: @cart)
        @order = create(:order, voucher: @voucher)
        @order.add_line_items(@cart)
      end

      it "can calculate total_price" do
        expect(@order.set_total_price).to eq(20000.0)
      end

      context "voucher in percent" do
        it "can calculate discount" do
          voucher = create(:voucher, amount: 10.0, unit: "Percent")
          order = create(:order, voucher: voucher)
          order.add_line_items(@cart)
          expect(order.discount).to eq(2000.0)
        end

        it "can calculate final_price" do
          voucher = create(:voucher, amount: 10.0, unit: "Percent")
          order = create(:order, voucher: voucher)
          order.add_line_items(@cart)
          expect(order.final_price).to eq(18000.0)
        end

        it "changes discount to max_amount if discount is bigger than max_amount" do
          voucher = create(:voucher, amount: 15.0, unit: "Percent", max_amount: 1000)
          order = create(:order, voucher: voucher)
          order.add_line_items(@cart)
          expect(order.final_price).to eq(19000.0)
        end
      end

      context "voucher in rupiah" do
        it "can calculate discount" do
          voucher = create(:voucher, amount: 3000.0, unit: "Rupiah")
          order = create(:order, voucher: voucher)
          order.add_line_items(@cart)
          expect(order.discount).to eq(3000.0)
        end

        it "can calculate final_price" do
          voucher = create(:voucher, amount: 3000.0, unit: "Rupiah")
          order = create(:order, voucher: voucher)
          order.add_line_items(@cart)
          expect(order.final_price).to eq(17000.0)
        end
      end
    end

    context "with invalid voucher" do
      # it "can calculate total_price without discount"
    end
  end
end
