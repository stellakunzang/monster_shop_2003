require 'rails_helper'

RSpec.describe "Items Index Page" do
  describe "When I visit the items index page" do
    before(:each) do
      login_user
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    end

    it "all items or merchant names are links" do
      visit '/items'

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@tire.merchant.name)
      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_link(@pull_toy.merchant.name)
    end

    it "I can see a list of all of the items "do

      visit '/items'

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@tire.inventory}")
        expect(page).to have_link(@meg.name)
        expect(page).to have_css("img[src*='#{@tire.image}']")
      end

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_link(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content("Price: $#{@pull_toy.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      end

    end

    it "All users can only see items that are not disabled" do

      visit '/items'

      expect(page).to_not have_link(@dog_bone.name)
      expect(page).to_not have_content(@dog_bone.description)
      expect(page).to_not have_content("Price: $#{@dog_bone.price}")
      expect(page).to_not have_content("Inactive")
      expect(page).to_not have_content("Inventory: #{@dog_bone.inventory}")
      expect(page).to_not have_css("img[src*='#{@dog_bone.image}']")
    end

    it "All users can click image and link to item's show page" do
      visit '/items'
      click_link("#{@tire.name}")
      expect(current_path).to eq("/items/#{@tire.id}")
    end

    it "All users can see top 5 most popular, including quantity purchased" do
      dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:true, inventory: 21)

      bone = @brian.items.create(name: "A Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:true, inventory: 21)

      toy = @brian.items.create(name: "A Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      order = Order.create!(name: "name", address: "address", city: "city", state: "state", zip: 23455, user_id: @user.id)
      order2 = Order.create!(name: "name", address: "address", city: "city", state: "state", zip: 23455, user_id: @user.id)

      ItemOrder.create!(order_id: order.id, price: 1.0, item_id: dog_bone.id, quantity: 5)
      ItemOrder.create!(order_id: order.id, price: 1.0, item_id: @pull_toy.id, quantity: 1)
      ItemOrder.create!(order_id: order.id, price: 1.0, item_id: @tire.id, quantity: 4)
      ItemOrder.create!(order_id: order.id, price: 1.0, item_id: toy.id, quantity: 3)
      ItemOrder.create!(order_id: order.id, price: 1.0, item_id: bone.id, quantity: 2)
      ItemOrder.create!(order_id: order2.id, price: 1.0, item_id: dog_bone.id, quantity: 3)
      ItemOrder.create!(order_id: order2.id, price: 1.0, item_id: @pull_toy.id, quantity: 4)

      visit "/items"

      within ".top_5" do
        expect(page).to have_content("Top 5 Most Popular Items:")

        expect(dog_bone.name).to appear_before(@pull_toy.name)
        expect(page).to have_content("Total Purchased: 8")

        expect(@pull_toy.name).to appear_before(@tire.name)
        expect(page).to have_content("Total Purchased: 5")

        expect(@tire.name).to appear_before(toy.name)
        expect(page).to have_content("Total Purchased: 4")

        expect(toy.name).to appear_before(bone.name)
        expect(page).to have_content("Total Purchased: 3")
        expect(page).to have_content("Total Purchased: 2")
      end
    end

    it "All users can see 5 least popular, including quantity purchased" do
      dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:true, inventory: 21)

      bone = @brian.items.create(name: "A Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:true, inventory: 21)

      toy = @brian.items.create(name: "A Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      order = Order.create!(name: "name", address: "address", city: "city", state: "state", zip: 23455, user_id: @user.id)
      order2 = Order.create!(name: "name", address: "address", city: "city", state: "state", zip: 23455, user_id: @user.id)

      ItemOrder.create!(order_id: order.id, price: 1.0, item_id: dog_bone.id, quantity: 5)
      ItemOrder.create!(order_id: order.id, price: 1.0, item_id: @pull_toy.id, quantity: 1)
      ItemOrder.create!(order_id: order.id, price: 1.0, item_id: @tire.id, quantity: 4)
      ItemOrder.create!(order_id: order.id, price: 1.0, item_id: toy.id, quantity: 3)
      ItemOrder.create!(order_id: order.id, price: 1.0, item_id: bone.id, quantity: 2)
      ItemOrder.create!(order_id: order2.id, price: 1.0, item_id: dog_bone.id, quantity: 3)
      ItemOrder.create!(order_id: order2.id, price: 1.0, item_id: @pull_toy.id, quantity: 4)

      visit "/items"

      within ".worst_5" do
        expect(page).to have_content("5 Least Popular Items:")

        expect(bone.name).to appear_before(toy.name)
        expect(page).to have_content("Total Purchased: 2")

        expect(toy.name).to appear_before(@tire.name)
        expect(page).to have_content("Total Purchased: 3")

        expect(@tire.name).to appear_before(@pull_toy.name)
        expect(page).to have_content("Total Purchased: 4")

        expect(@pull_toy.name).to appear_before(dog_bone.name)
        expect(page).to have_content("Total Purchased: 5")
        expect(page).to have_content("Total Purchased: 8")
      end
    end
  end
end
