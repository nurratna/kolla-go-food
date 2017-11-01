require 'rails_helper'

RSpec.describe Cart, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it 'has a valid factory' do
    expect(build(:cart)).to be_valid
  end

  it "deletes line_items when deleted" do
    cart = create(:cart)
    food1 = create(:food)
    food2 = create(:food)
    line_item1 = create(:line_item, cart: cart, food: food1)
    line_item2 = create(:line_item, cart: cart, food: food2)
    cart.line_items << line_item1
    cart.line_items << line_item2

    expect { cart.destroy }.to change { LineItem.count }.by(-2)
  end

  it 'change the number of line_item if not the same food is added' do
    cart = create(:cart)
    food = create(:food)

    expect { cart.add_food(food).save }.to change(LineItem, :count).by(1)
  end

  it "does not change the number of line_item if the same food is added" do
    cart = create(:cart)
    food = create(:food, name: "Nasi Uduk")

    expect { cart.add_food(food) }.not_to change(LineItem, :count)
  end

  it "increments the quantity of line_item if the same food is added" do
    cart = create(:cart)
    food = create(:food, name: "Nasi Uduk")
    line_item = create(:line_item, food: food, cart: cart)

    expect(cart.add_food(food).quantity).to eq(2)
  end

  it 'can calculate total_price' do
    cart = create(:cart)
    food1 = create(:food, name: 'Nasi Uduk', price: 10000.0)
    food2 = create(:food, name: 'Nasi Goreng', price: 20000.0)
    line_item1 = create(:line_item, quantity: 3, food: food1, cart: cart)
    line_item2 = create(:line_item, quantity: 2, food: food2, cart: cart)

    expect(cart.total_price).to eq(70000.0)
  end

  it "does not remove the other user's cart"
end
