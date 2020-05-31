require 'rails_helper'

RSpec.describe "Logging in" do
    before(:each) do
      @merchant_1 = Merchant.create(name: "Maude Sloggett", address: "17 Sun Rise St", city: "El Paso", state: "Illinois", zip: "56726")
      @regular_user = User.create(name: "Willy Wonka", address: "123 St", city: "Denver", state: "CO", zip: "12345", email: "chocolateguy1@gmail.com", password: "loco123", role: 1, merchant_id: @merchant_1.id)
    end

    it "I see a field to enter my email address and password for regular user with logged in flash" do

      visit "/"

      click_on "Sign in"

      expect(current_path).to eq('/login')

        fill_in :email, with: @regular_user.email
        fill_in :password, with: @regular_user.password
        click_on "Login!"

        expect(current_path).to eq('/merchant')

        expect(page).to have_content("Welcome, #{@regular_user.name}")
        expect(page).to have_link("Log out")
        expect(page).to have_content("You are now logged in.")
        expect(page).to_not have_link("Register")
        expect(page).to_not have_link("Sign in")
    end
    it "Users who are logged in already are redirected" do

      visit "/"

      click_on "Sign in"

      fill_in :email, with: @regular_user.email
      fill_in :password, with: @regular_user.password

      click_on "Login!"

      expect(current_path).to eq('/merchant')

      visit "/login"

      expect(current_path).to eq('/merchant')

      expect(page).to have_content("Merchant Dashboard")
      expect(page).to have_link("Log out")
      expect(page).to_not have_link("Register")
      expect(page).to_not have_link("Sign in")
    end
end
