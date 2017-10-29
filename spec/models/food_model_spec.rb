require 'rails_helper'

describe Food do
  it "has a valid factory" do
    expect(FactoryGirl.build(:food)).to be_valid
  end

  it "is valid with a name and description" do
    expect(FactoryGirl.build(:food)).to be_valid
  end

  it "is invalid without a name" do
    food = FactoryGirl.build(:food, name: nil)
    food.valid?
    expect(food.errors[:name]).to include("can't be blank")
  end

  it "is invalid without a description" do
    food = FactoryGirl.build(:food, description: nil)
    food.valid?
    expect(food.errors[:description]).to include("can't be blank")
  end

  it "is invalid with a duplicate name" do
    food1 = FactoryGirl.create(:food, name: "Nasi Uduk")
    food2 = FactoryGirl.build(:food, name: "Nasi Uduk")

    food2.valid?
    expect(food2.errors[:name]).to include("has already been taken")
  end
end
