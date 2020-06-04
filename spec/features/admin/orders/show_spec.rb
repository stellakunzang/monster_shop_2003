require 'rails_helper'

RSpec.describe "Admin Orders Show" do
  before(:each) do
    login_admin
    @regular_user = User.create(name: "Willy Wonka", address: "123 St", city: "Denver", state: "CO", zip: "12345", email: "chocolateguy1@gmail.com", password: "loco123", role: 0)
    @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    @order1 = Order.create!(name: "Dan", address: "address", city: "city", state: "state", zip: 23455, user_id: @regular_user.id, status: "cancelled")
    @order2 = Order.create!(name: "Marjorie Salad", address: "address", city: "city", state: "state", zip: 23455, user_id: @regular_user.id, status: "shipped")
    @order3 = Order.create!(name: "October", address: "address", city: "city", state: "state", zip: 23455, user_id: @regular_user.id, status: "pending")
    @order4 = Order.create!(name: "Louis", address: "address", city: "city", state: "state", zip: 23455, user_id: @regular_user.id, status: "packaged")
    @itemorder1 = ItemOrder.create!(order_id: @order4.id, price: 1.0, item_id: @dog_bone.id, quantity: 5)
    @itemorder2 = ItemOrder.create!(order_id: @order4.id, price: 1.0, item_id: @tire.id, quantity: 5)

  end

  it "displays all information about order" do
    visit "/admin/users/#{@regular_user.id}/orders/#{@order4.id}"
    expect(page).to have_content("#{@order4.id}")
    expect(page).to have_content("#{@order4.created_at}")
    expect(page).to have_content("#{@order4.updated_at}")
    expect(page).to have_content("#{@order4.status}")

    within "#item-#{@dog_bone.id}" do
      expect(page).to have_content("#{@dog_bone.name}")
      expect(page).to have_content("#{@dog_bone.description}")
      expect(page).to have_css("img[src*='#{@dog_bone.image}']")
      expect(page).to have_content("#{@itemorder1.quantity}")
      expect(page).to have_content("#{@itemorder1.price}")
      expect(page).to have_content("#{@itemorder1.subtotal}")
    end
    within "#item-#{@tire.id}" do
      expect(page).to have_content("#{@tire.name}")
      expect(page).to have_content("#{@tire.description}")
      expect(page).to have_css("img[src*='#{@tire.image}']")
      expect(page).to have_content("#{@itemorder2.quantity}")
      expect(page).to have_content("#{@itemorder2.price}")
      expect(page).to have_content("#{@itemorder2.subtotal}")
    end

    expect(page).to have_content("#{@order4.quantity_sum}")
    expect(page).to have_content("#{@order4.grandtotal}")
  end
end
