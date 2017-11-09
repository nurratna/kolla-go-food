require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  it "has a valid factory" do
    expect(build(:restaurant)).to be_valid
  end

  it "is valid with name and address" do
    expect(build(:restaurant)).to be_valid
  end

  it "is invalid without name" do
    resto = build(:restaurant, name: nil)
    resto.valid?
    expect(resto.errors[:name]).to include("can't be blank")
  end

  it "is invalid without address" do
    resto = build(:restaurant, address: nil)
    resto.valid?
    expect(resto.errors[:address]).to include("can't be blank")
  end
end
