require 'rails_helper'

RSpec.describe "Orders show page" do
  before(:each) do
    @regular_user = User.create(name: "Willy Wonka", address: "123 St", city: "Denver", state: "CO", zip: "12345", email: "chocolateguy1@gmail.com", password: "loco123", role: 0)
    @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    @order1 = Order.create!(name: "name", address: "address", city: "city", state: "state", zip: 23455, user_id: @regular_user.id)
    @order2 = Order.create!(name: "name", address: "address", city: "city", state: "state", zip: 23455, user_id: @regular_user.id)
    @itemorder1 = ItemOrder.create!(order_id: @order1.id, price: 1.0, item_id: @dog_bone.id, quantity: 5)
    @itemorder2 = ItemOrder.create!(order_id: @order1.id, price: 1.0, item_id: @pull_toy.id, quantity: 1)
    @itemorder3 = ItemOrder.create!(order_id: @order2.id, price: 1.0, item_id: @tire.id, quantity: 4)

    visit '/login'
    fill_in :email, with: @regular_user.email
    fill_in :password, with: @regular_user.password
    click_on "Login!"
  end

  it "displays order information" do
    visit "/profile/orders/#{@order1.id}"

    expect(page).to have_content("#{@order1.id}")
    expect(page).to have_content("#{@order1.created_at}")
    expect(page).to have_content("#{@order1.updated_at}")
    expect(page).to have_content("#{@order1.status}")
  end

  it "displays item information" do
    visit "/profile/orders/#{@order1.id}"

    within "#item-#{@pull_toy.id}" do
      expect(page).to have_content("#{@pull_toy.name}")
      expect(page).to have_content("#{@pull_toy.description}")
      expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      expect(page).to have_content("#{@itemorder2.quantity}")
      expect(page).to have_content("#{@itemorder2.price}")
      expect(page).to have_content("#{@itemorder2.subtotal}")
    end

    within "#item-#{@dog_bone.id}" do
      expect(page).to have_content("#{@dog_bone.name}")
      expect(page).to have_content("#{@dog_bone.description}")
      expect(page).to have_css("img[src*='#{@dog_bone.image}']")
      expect(page).to have_content("#{@itemorder1.quantity}")
      expect(page).to have_content("#{@itemorder1.price}")
      expect(page).to have_content("#{@itemorder1.subtotal}")
    end

    expect(page).to have_content("#{@order1.quantity_sum}")
    expect(page).to have_content("#{@order1.grandtotal}")
  end
end
