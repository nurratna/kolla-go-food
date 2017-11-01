require 'rails_helper'

describe Category do
  it 'has a valid factory' do
    expect(build(:category)).to be_valid
  end

  it 'is valid with a name' do
    expect(build(:category)).to be_valid
  end

  it 'is invalid without name' do
    category = build(:category, name:nil)
    category.valid?
    expect(category.errors[:name]).to include("can't be blank")
  end

  # it 'is invalid with a duplicate name' do
  #   category1 = create(:category, name: 'Japanese')
  #   category2 = create(:category, name: 'Japanese')
  #
  #   category2.valid?
  #   expect(category2.errors[:name]).to include("has already been taken")
  # end
  #
  # it 'can not be destroyed when food is using it' do
  #   category = create(:category)
  #   food = create(:food, category: category)
  #
  #   expect { category.destroy }.not_to change(Category, :count)
  # end
end
