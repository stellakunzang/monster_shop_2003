require 'rails_helper'

RSpec.describe "Merchant Items Index Page" do
  describe "When I visit the merchant items page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      @shifter = @meg.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)
      @maude = @meg.users.create!(name: "Maude Sloggett", address: "17 Sun Rise St", city: "El Paso", state: "Illinois", zip: "56726", email: "M.Slogget@yahoo.com", password: "Forever27", role: 1)

      visit '/login'
      fill_in :email, with: @maude.email
      fill_in :password, with: @maude.password
      click_on "Login!"
    end

    it 'shows me a list of that merchants items, regardless of active status' do

      visit "merchant/items"

      within "#item-#{@tire.id}" do
        expect(page).to have_content(@tire.name)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_css("img[src*='#{@tire.image}']")
        expect(page).to have_content("Active")
        expect(page).to have_content(@tire.description)
        expect(page).to have_content("Inventory: #{@tire.inventory}")
      end

      within "#item-#{@chain.id}" do
        expect(page).to have_content(@chain.name)
        expect(page).to have_content("Price: $#{@chain.price}")
        expect(page).to have_css("img[src*='#{@chain.image}']")
        expect(page).to have_content("Active")
        expect(page).to have_content(@chain.description)
        expect(page).to have_content("Inventory: #{@chain.inventory}")
      end

      within "#item-#{@shifter.id}" do
        expect(page).to have_content(@shifter.name)
        expect(page).to have_content("Price: $#{@shifter.price}")
        expect(page).to have_css("img[src*='#{@shifter.image}']")
        expect(page).to have_content("Inactive")
        expect(page).to have_content(@shifter.description)
        expect(page).to have_content("Inventory: #{@shifter.inventory}")
      end
    end
    it "shows me a link to enable or disable for each item" do
      visit "merchant/items"

      within "#item-#{@tire.id}" do
        click_link "disable"
      end

      expect(current_path).to eq("/merchant/items")
      expect(page).to have_content("#{@tire.name} is now inactive!")

      within "#item-#{@chain.id}" do
        click_link "disable"
      end

      expect(current_path).to eq("/merchant/items")
      expect(page).to have_content("#{@chain.name} is now inactive!")

      within "#item-#{@shifter.id}" do
        click_link "enable"
      end

      expect(current_path).to eq("/merchant/items")
      expect(page).to have_content("#{@shifter.name} is now active!")

      within "#item-#{@tire.id}" do
        expect(page).to have_link("enable")
      end

      within "#item-#{@chain.id}" do
        expect(page).to have_link("enable")
      end

      within "#item-#{@shifter.id}" do
        expect(page).to have_link("disable")
      end
    end

    it "shows me a functioning 'edit' link next to each item" do
      visit "merchant/items"

      within "#item-#{@tire.id}" do
        expect(page).to have_link("edit")
      end

      within "#item-#{@chain.id}" do
        expect(page).to have_link("edit")
      end

      within "#item-#{@shifter.id}" do
        click_link "edit"
      end

      expect(current_path).to eq("/merchant/items/#{@shifter.id}/edit")
    end
    it "I see a button or link to delete the item next to each item that has never been ordered" do
      default_1 = User.create(name: "Hank Hill", address: "801 N Alamo St", city: "Arlen", state: "Texas", zip: "61109", email: "ProPAIN@aol.com", password: "W33dWacker", role: 0)
      order = Order.create!(name: "name", address: "address", city: "city", state: "state", zip: 23455, user_id: default_1.id)
      ItemOrder.create!(order_id: order.id, price: 1.0, item_id: @tire.id, quantity: 1)


      visit "/merchant/items"


      within "#item-#{@tire.id}" do
        expect(page).to have_content(@tire.name)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_css("img[src*='#{@tire.image}']")
        expect(page).to have_content("Active")

        expect(page).to have_content(@tire.description)

        expect(page).to have_content("Inventory: #{@tire.inventory}")
        expect(page).to_not have_content("Delete")
      end

      within "#item-#{@chain.id}" do
        expect(page).to have_content(@chain.name)
        expect(page).to have_content("Price: $#{@chain.price}")
        expect(page).to have_css("img[src*='#{@chain.image}']")
        expect(page).to have_content("Active")

        expect(page).to have_content(@chain.description)

        expect(page).to have_content("Inventory: #{@chain.inventory}")
        expect(page).to have_content("Delete")
      end

      within "#item-#{@chain.id}" do
        click_link("Delete")
      end

      expect(current_path).to eq("/merchant/items")
      expect(page).to have_content("Item Deleted")

      expect(page).to_not have_css("#item-#{@chain.id}")
    end
    it "I see a link to add a new item" do 
      visit "/merchant/items"

      expect(page).not_to have_content("Disco Ball")
      expect(page).not_to have_content("Has a ghost from the 70s trapped inside")
      expect(page).not_to have_css("img[src*='https://i.pinimg.com/originals/68/d1/5b/68d15b22b2b5aa18197a4578f5daf879.jpg']")
      expect(page).not_to have_content("$991.00")
      expect(page).not_to have_content("Inventory:999999")
      click_link("Create new item")

      expect(current_path).to eq("/merchant/items/new")

      fill_in 'Name', with: "Disco Ball"
      fill_in 'Price', with: 991
      fill_in 'Description', with: "Has a ghost from the 70s trapped inside"
      fill_in 'Image', with: "https://i.pinimg.com/originals/68/d1/5b/68d15b22b2b5aa18197a4578f5daf879.jpg"
      fill_in 'Inventory', with: 1
     
      click_on("Create Item")

      expect(current_path).to eq("/merchant/items")

      expect(page).to have_content("Disco Ball")
      expect(page).to have_content("Has a ghost from the 70s trapped inside")
      expect(page).to have_css("img[src*='https://i.pinimg.com/originals/68/d1/5b/68d15b22b2b5aa18197a4578f5daf879.jpg']")
      expect(page).to have_content("$991.00")
      expect(page).to have_content("Inventory: 1")
      expect(page).to have_content("Create new item")
      expect(page).to have_content("Nailed it!")

    end
    it "If any of my data is incorrect or missing (except image) returned to form" do 
      visit '/merchant/items/new'

      within ".form" do
        fill_in 'Name', with: ""

        click_button "Create Item"
      end
      expect(current_path).to eq("/merchant/items/new")
      expect(page).to have_content("Name can't be blank")

      within ".form" do
        fill_in 'Name', with: "Shifty Shift"
        fill_in 'Description', with: ""

        click_button "Create Item"
      end
      expect(current_path).to eq("/merchant/items/new")
      expect(page).to have_content("Description can't be blank")

      within ".form" do
        fill_in 'Description', with: "Tastes kinda good..."
        fill_in 'Price', with: "-3"

        click_button "Create Item"
      end
      expect(current_path).to eq("/merchant/items/new")
      expect(page).to have_content("Price must be greater than -1")

      within ".form" do
        fill_in 'Price', with: "3"
        fill_in 'Inventory', with: "-1"

        click_button "Create Item"
      end
      expect(current_path).to eq("/merchant/items/new")
      expect(page).to have_content("Inventory must be greater than -1")
    end
  end
end




# User Story 46, Merchant cannot add an item if details are bad/missing

# As a merchant employee
# When I try to add a new item
# If any of my data is incorrect or missing (except image)
# Then I am returned to the form
# I see one or more flash messages indicating each error I caused
# All fields are re-populated with my previous data
