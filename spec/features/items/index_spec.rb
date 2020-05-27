require 'rails_helper'

RSpec.describe "Items Index Page" do
  describe "When I visit the items index page" do
    before(:each) do
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

    xit "All users can click image and link to item's show page" do
      visit '/items'
      find("img[alt='#{@tire.name}']").click
      expect(current_path).to eq("items/#{@tire.id}")
    end

    it "All users can see top 5 most popular, including quantity purchased" do

      bone = @brian.items.create(name: "Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

      toy = @brian.items.create(name: "Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      order = Order.create!(name: "name", address: "address", city: "city", state: "state", zip: 23455)
      order2 = Order.create!(name: "name", address: "address", city: "city", state: "state", zip: 23455)

      ItemOrder.create!(order_id: order.id, price: 1.0, item_id: @dog_bone.id, quantity: 5)
      ItemOrder.create!(order_id: order.id, price: 1.0, item_id: @pull_toy.id, quantity: 1)
      ItemOrder.create!(order_id: order.id, price: 1.0, item_id: @tire.id, quantity: 4)
      ItemOrder.create!(order_id: order.id, price: 1.0, item_id: toy.id, quantity: 3)
      ItemOrder.create!(order_id: order.id, price: 1.0, item_id: bone.id, quantity: 2)
      ItemOrder.create!(order_id: order2.id, price: 1.0, item_id: @dog_bone.id, quantity: 3)
      ItemOrder.create!(order_id: order2.id, price: 1.0, item_id: @pull_toy.id, quantity: 4)

      visit "/items"

      expect(page).to have_content("Top 5 Most Popular Items:")
      expect(page).to have_content("1) #{@dog_bone.name} (Total Purchased = 8)")
      expect(page).to have_content("2) #{@pull_toy.name} (Total Purchased = 5)")
      expect(page).to have_content("3) #{@tire.name} (Total Purchased = 4)")
      expect(page).to have_content("4) #{toy.name} (Total Purchased = 3)")
      expect(page).to have_content("5) #{bone.name} (Total Purchased = 2)")

    end

    it "All users can see 5 least popular, including quantity purchased" do
    end 
  end
end
