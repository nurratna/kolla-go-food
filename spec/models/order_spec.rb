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
    order = build(:order, address:nil)
    order.valid?
    expect(order.errors[:address]).to include("can't be blank")
  end

  it 'is invalid with wrong payment_type' do
    expect{ build(:order, payment_type: 'Go Pay') }.to raise_error(ArgumentError)
  end
end
