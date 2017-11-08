require 'rails_helper'

RSpec.describe Tag, type: :model do
  it "has a valid factory" do
    expect(build(:tag)).to be_valid
  end

  it "is valid a name" do
    expect(build(:tag)).to be_valid
  end

  it "is invalid without a name" do
    tag = build(:tag, name: nil)
    tag.valid?
    expect(tag.errors[:name]).to include("can't be blank")
  end

  describe "relations" do
    it { should have_and_belong_to_many(:foods) }
  end
end
