require 'rails_helper'

RSpec.describe "editing a merchant item" do
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

  context "when a form is filled out properly" do
    it "updates the item and redirects to merchant item index" do
      visit "/merchant/items/#{@shifter.id}/edit"

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
      expect(current_path).to eq("/merchant/items")
      expect(page).to have_content("Git Shifty has been updated!")

      within "#item-#{@shifter.id}" do
        expect(page).to have_content("Git Shifty")
        expect(page).to have_content("Tastes BAD!")
        expect(page).to have_content("$150.00")
        expect(page).to have_content("10")
      end
    end

    # it "handles edge cases" do
    #   visit "/merchant/items/#{@shifter.id}/edit"
    #
    #   within ".form" do
    #     fill_in 'Price', with: "0.00"
    #     fill_in 'Inventory', with: "0.00"
    #     fill_in 'Image', with: ""
    #
    #     click_button "Update Item"
    #   end
    #   expect(current_path).to eq("/merchant/items")
    #   expect(page).to have_content("Git Shifty has been updated!")
    # end
  end

  context "when a form is filled out incorrectly" do
    it "wont allow any missing or faulty values in required fields" do
      visit "/merchant/items/#{@shifter.id}/edit"

      within ".form" do
        fill_in 'Name', with: ""

        click_button "Update Item"
      end
      expect(current_path).to eq("/merchant/items/#{@shifter.id}/edit")
      expect(page).to have_content("Name can't be blank")

      within ".form" do
        fill_in 'Name', with: "Shifty Shift"
        fill_in 'Description', with: ""

        click_button "Update Item"
      end
      expect(current_path).to eq("/merchant/items/#{@shifter.id}/edit")
      expect(page).to have_content("Description can't be blank")

      within ".form" do
        fill_in 'Description', with: "Tastes kinda good..."
        fill_in 'Price', with: "-3"

        click_button "Update Item"
      end
      expect(current_path).to eq("/merchant/items/#{@shifter.id}/edit")
      expect(page).to have_content("Price must be greater than 0")

      # within ".form" do
      #   fill_in 'Price', with: "3"
      #   fill_in 'Inventory', with: "-1"
      #
      #   click_button "Update Item"
      # end
      # expect(current_path).to eq("/merchant/items/#{@shifter.id}/edit")
      # expect(page).to have_content("Inventory must be greater than 0")
    end
  end
end
