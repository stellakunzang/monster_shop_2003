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
        expect(page).to_not have_content(@tire.description)
        expect(page).to have_content("Inventory: #{@tire.inventory}")
      end

      within "#item-#{@chain.id}" do
        expect(page).to have_content(@chain.name)
        expect(page).to have_content("Price: $#{@chain.price}")
        expect(page).to have_css("img[src*='#{@chain.image}']")
        expect(page).to have_content("Active")
        expect(page).to_not have_content(@chain.description)
        expect(page).to have_content("Inventory: #{@chain.inventory}")
      end

      within "#item-#{@shifter.id}" do
        expect(page).to have_content(@shifter.name)
        expect(page).to have_content("Price: $#{@shifter.price}")
        expect(page).to have_css("img[src*='#{@shifter.image}']")
        expect(page).to have_content("Inactive")
        expect(page).to_not have_content(@shifter.description)
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

      within ".form" do
        expect(find_field('Name').value).to eq("Shimano Shifters")
        expect(find_field('Description').value).to eq("It'll always shift!")
        expect(find_field('Price').value).to eq("$180.00")
        expect(find_field('Image').value).to eq(@shifter.image)
        expect(find_field('Inventory').value).to eq("2")

        fill_in 'Name', with: "Git Shifty"
        fill_in 'Description', with: "Tastes BAD!"
        fill_in 'Price', with: "150.00"
        fill_in 'Image', with: ""
        fill_in 'Inventory', with: "10"

        click_button "Update Item"
      end

      within ".form" do
        expect(find_field('Name').value).to eq("Git Shifty")
        expect(find_field('Description').value).to eq("Tastes BAD!")
        expect(find_field('Price').value).to eq("$150.00")
        expect(find_field('Image').value).to eq("")
        expect(find_field('Inventory').value).to eq("10")
      end
    end
  end
end
