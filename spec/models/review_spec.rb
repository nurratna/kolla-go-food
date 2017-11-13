require 'rails_helper'

RSpec.describe Review, type: :model do
  it "has a valid factory" do
    expect(build(:review)).to be_valid
  end

  it "is valid with name, title, and description" do
    expect(build(:review)).to be_valid
  end

  it "is invalid without name" do
    review = build(:review, name: nil)
    review.valid?
    expect(review.errors[:name]).to include("can't be blank")
  end

  it "is invalid without title" do
    review = build(:review, title: nil)
    review.valid?
    expect(review.errors[:title]).to include("can't be blank")
  end

  it "is invalid without description" do
    review = build(:review, description: nil)
    review.valid?
    expect(review.errors[:description]).to include("can't be blank")
  end

  it "is invalid with duplicate name" do
    review1 = create(:review, name: "Review 1")
    review2 = build(:review, name: "Review 1")
    review2.valid?
    expect(review2.errors[:name]).to include("has already been taken")
  end
end
