require 'rails_helper'

RSpec.describe "Admin dashboard" do
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
  end

    it "shows all orders in the system, sorted by status" do
      visit "/admin"

      expect(page).to have_content("#{@order1.id}")
      expect(page).to have_link("#{@order1.user.name}")
      expect(page).to have_content("#{@order1.created_at.strftime('%m/%d/%Y')}")

      expect(page).to have_content("#{@order2.id}")
      expect(page).to have_link("#{@order2.user.name}")
      expect(page).to have_content("#{@order2.created_at.strftime('%m/%d/%Y')}")

      expect(page).to have_content("#{@order3.id}")
      expect(page).to have_link("#{@order3.user.name}")
      expect(page).to have_content("#{@order3.created_at.strftime('%m/%d/%Y')}")

      expect(page).to have_content("#{@order4.id}")
      expect(page).to have_link("#{@order4.user.name}")
      expect(page).to have_content("#{@order4.created_at.strftime('%m/%d/%Y')}")

      expect("#{@order4.id}").to appear_before("#{@order3.id}")
      expect("#{@order3.id}").to appear_before("#{@order2.id}")
      expect("#{@order2.id}").to appear_before("#{@order1.id}")
    end

    it "user name is link to the admin view of their profile" do
      visit "/admin"

      within "#cancelled" do
        click_link "#{@order2.user.name}"
      end

      expect(current_path).to eq("/admin/profile/#{@order2.user_id}")
    end

    it "packaged orders can be shipped and user can no longer cancel" do
      visit "/admin"

      within "#packaged" do
        click_link "Ship Order"
      end

      expect(current_path).to eq("/admin")
      @order4.reload
      expect(@order4.status).to eq("shipped")
    end

  end
