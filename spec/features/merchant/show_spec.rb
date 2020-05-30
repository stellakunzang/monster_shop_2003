require 'rails_helper'

RSpec.describe "Merchant employee dashboard show page" do

  before(:each) do
    @dog_shop = Merchant.create!(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203)
    @maude = @dog_shop.users.create!(name: "Maude Sloggett", address: "17 Sun Rise St", city: "El Paso", state: "Illinois", zip: "56726", email: "M.Slogget@yahoo.com", password: "Forever27", role: 1)
    @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @pull_toy = Item.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32, merchant_id: @dog_shop.id)
    @dog_bone = Item.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 21, merchant_id: @dog_shop.id)
    @tire = @bike_shop.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

    @order = Order.create!(name: "name", address: "address", city: "city", state: "state", zip: 23455)

    ItemOrder.create!(order_id: @order.id, price: 1.0, item_id: @dog_bone.id, quantity: 5)
    ItemOrder.create!(order_id: @order.id, price: 1.0, item_id: @pull_toy.id, quantity: 1)
    ItemOrder.create!(order_id: @order.id, price: 1.0, item_id: @tire.id, quantity: 4)

    visit '/login'
    fill_in :email, with: @maude.email
    fill_in :password, with: @maude.password
    click_on "Login!"
  end

  it "displays name and address of merchant employer" do

    visit '/merchant'

    expect(page).to have_content(@dog_shop.name)
    expect(page).to have_content(@dog_shop.address)
    expect(page).to have_content(@dog_shop.city)
    expect(page).to have_content(@dog_shop.state)
    expect(page).to have_content(@dog_shop.zip)

  end

  it "displays order ids of orders with pending status that my shop sells" do

    visit "/merchant"

    expect(page).to have_content(@order.id)
    click_on @order.id
    expect(current_path).to eq("/merchant/orders/#{@order.id}")
  end

  it "displays assorted informaton about pending orders" do
    visit "/merchant"
    expect(page).to have_content(@order.created_at.strftime('%m/%d/%Y'))
    expect(page).to have_content("Total Quantity: 6")
    expect(page).to have_content("Total Value: $6.00")
  end
end
