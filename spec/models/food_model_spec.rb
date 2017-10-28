require 'rails_helper'

describe Food do
  it 'is valid with a name and description' do
    food = Food.new(
      name: 'Nasi Uduk',
      description: 'Betawi style steamed rice cooked in coconut milk. Delicious!',
      price: 10000.0
    )
    expect(food).to be_valid
  end

  describe 'invalid without name or description' do
    before :each do
      @food = Food.new(
        name: nil,
        description: nil,
        price: 10000.0
      )
    end

    it 'is invalid without name' do
      @food.valid?
      expect(@food.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without description' do
      @food.valid?
      expect(@food.errors[:description]).to include("can't be blank")
    end
  end

  it 'is invalid with a duplicate name' do
    food1 = Food.create(
      name: 'Nasi Uduk',
      description: 'Betawi style steamed rice cooked in coconut milk. Delicious!',
      price: 10000.0
    )

    food2 = Food.new(
      name: 'Nasi Uduk',
      description: 'Just with a different description.',
      price: 10000.0
    )

    food2.valid?
    expect(food2.errors[:name]).to include('has already been taken')
  end

  describe 'filter name by letter' do
    before :each do
      @food1 = Food.create(
        name: 'Nasi Uduk',
        description: 'Betawi style steamed rice cooked in coconut milk. Delicious!',
        price: 10000.0
      )

      @food2 = Food.create(
        name: 'Kerak Telor',
        description: 'Betawi traditional spicy omelette made from glutinous rice cooked with egg and served with serundeng.',
        price: 8000.0
      )

      @food3 = Food.create(
        name: 'Nasi Semur Jengkol',
        description: 'Based on dongfruit, this menu promises a unique and delicious taste with a small hint of bitterness.',
        price: 8000.0
      )
    end

    # We put the contexts below before block
    context 'with matching letters' do
      it 'returns a sorted array of results that match' do
        expect(Food.by_letter('N')).to eq([@food3, @food1])
      end
    end

    context 'with non-matching letters' do
      it 'omits results that do not match' do
        expect(Food.by_letter('N')).not_to include(@food2)
      end
    end
  end

  it 'is valid with numeric price greater or equal to 0.01' do
    food = Food.new(
      name: 'Nasi Uduk',
      description: 'Betawi style steamed rice cooked in coconut milk. Delicious!',
      price: 0.01
    )

    expect(food).to be_valid
  end

  it 'is invalid with non numeric price greater or equal to 0.01' do
    food = Food.new(
      name: 'Nasi Uduk',
      description: 'Betawi style steamed rice cooked in coconut milk. Delicious!',
      price: 0
    )

		food.valid?
		expect(food.errors[:price]).to include('must be greater than or equal to 0.01')
	end

  it 'is valid with numeric price' do
    food = Food.new(
      name: 'Nasi Uduk',
      description: 'Betawi style steamed rice cooked in coconut milk. Delicious!',
      price: 0.01
    )

    expect(food).to be_valid
  end

  it 'is invalid with non numeric price' do
    food = Food.new(
      name: 'Nasi Uduk',
      description: 'Betawi style steamed rice cooked in coconut milk. Delicious!',
      price: 'sepuluh'
    )

    food.valid?
    expect(food.errors[:price]).to include('is not a number')
  end

  it "is valid with image_url ending with '.gif', '.jpg', or '.png'" do
    food = Food.new(
      name: 'Nasi Uduk',
      description: 'Betawi style steamed rice cooked in coconut milk. Delicious!',
      image_url: 'nasi_uduk.jpg',
      price: 0.01
    )

    expect(food).to be_valid
  end

  it "is invalid with image_url ending not with '.gif', '.jpg', or '.png'" do
    food = Food.new(
      name: 'Nasi Uduk',
      description: 'Betawi style steamed rice cooked in coconut milk. Delicious!',
      image_url: 'nasi_uduk.pdf',
      price: 0.01
    )

    food.valid?
    expect(food.errors[:image_url]).to include('must be a URL for GIF, JPG or PNG image')
  end
end
