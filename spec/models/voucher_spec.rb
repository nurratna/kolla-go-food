require 'rails_helper'

describe Voucher do
  it "has a valid factory" do
    expect(build(:voucher)).to be_valid
  end

  it "is valid with code, valid_from, valid_through, amount, unit, max_amount" do
    expect(build(:voucher)).to be_valid
  end

  it "is invalid without a code" do
    voucher = build(:voucher, code: nil)
    voucher.valid?
    expect(voucher.errors[:code]).to include("can't be blank")
  end

  it "is invalid without a valid from" do
    voucher = build(:voucher, valid_from: nil)
    voucher.valid?
    expect(voucher.errors[:valid_from]).to include("can't be blank")
  end

  it "is invalid without a valid through" do
    voucher = build(:voucher, valid_through: nil)
    voucher.valid?
    expect(voucher.errors[:valid_through]).to include("can't be blank")
  end

  it "is invalid without a amount" do
    voucher = build(:voucher, amount: nil)
    voucher.valid?
    expect(voucher.errors[:amount]).to include("can't be blank")
  end

  it "is invalid without a max amount" do
    voucher = build(:voucher, max_amount: nil)
    voucher.valid?
    expect(voucher.errors[:max_amount]).to include("can't be blank")
  end

  it "is invalid without a unit" do
    voucher = build(:voucher, unit: nil)
    voucher.valid?
    expect(voucher.errors[:unit]).to include("can't be blank")
  end

  it "is invalid with wrong unit" do
    expect{
      build(:order, payment_type: 'dollar')
    }.to raise_error(ArgumentError)
  end

  # it "is invalid with wrong unit" do
  #   voucher = build(:voucher, unit: "dollar")
  #   voucher.valid?
  #   expect(voucher.errors[:unit]).to include("is not a valid unit")
  # end

  it "is invalid with a duplicate code" do
    voucher1 = create(:voucher, code: "PROMO")
    voucher2 = build(:voucher, code: "PROMO")

    voucher2.valid?
    expect(voucher2.errors[:code]).to include("has already been taken")
  end

  it "is invallid without numeric amount" do
    voucher = build(:voucher, amount: "12ribu")
    voucher.valid?
    expect(voucher.errors[:amount]).to include("is not a number")
  end

  it "is invallid without numeric max_amount" do
    voucher = build(:voucher, max_amount: "12ribu")
    voucher.valid?
    expect(voucher.errors[:max_amount]).to include("is not a number")
  end

  it "is invalid with amount a negative float value" do
    voucher = build(:voucher, amount: -10)
    voucher.valid?
    expect(voucher.errors[:amount]).to include("must be greater than or equal to 0.01")
  end

  it "is invalid with max amount a negative float value" do
    voucher = build(:voucher, max_amount: -10)
    voucher.valid?
    expect(voucher.errors[:max_amount]).to include("must be greater than or equal to 0.01")
  end

  it "is invalid with valid through > valid from" do
    voucher = build(:voucher, valid_from: "2017-11-06", valid_through: "2017-11-05")
    voucher.valid?
    expect(voucher.errors[:valid_through]).to include("valid_from must be less than valid_through")
  end

  context "with unit value rupiah" do
    it "is invalid with less than amount" do
      voucher = build(:voucher, unit: "Rupiah", amount: 5000, max_amount: 3000)
      voucher.valid?
      expect(voucher.errors[:max_amount]).to include("must be greather or equal to amount")
    end
  end

  it "saves code in all capital letters" do
    voucher = create(:voucher, code: "promo")
    expect(voucher.code).to eq("PROMO")
  end

  it "is invalid with case insensitive duplicate code" do
    voucher1 = create(:voucher, code: "PROMO")
    voucher2 = build(:voucher, code: "promo")
    voucher2.valid?
    expect(voucher2.errors[:code]).to include("has already been taken")
  end

  it "can't be destroyed while it has order(s)" do
    voucher = create(:voucher)
    order = create(:order, voucher: voucher)
    expect{ voucher.destroy }.not_to change(Voucher, :count)
  end
end
