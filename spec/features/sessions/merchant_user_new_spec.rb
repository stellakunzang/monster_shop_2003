require 'rails_helper'

RSpec.describe "Logging in" do
    before(:each) do
      # require 'pry', binding.pry
      @merchant_1 = Merchant.create(name: "Maude Sloggett", address: "17 Sun Rise St", city: "El Paso", state: "Illinois", zip: "56726")
      @regular_user = User.create(name: "Willy Wonka", address: "123 St", city: "Denver", state: "CO", zip: "12345", email: "chocolateguy1@gmail.com", password: "loco123", role: 1, merchant_id: @merchant_1.id)
      # @regular_user.merchant = @merchant_1
    end

    it "I see a field to enter my email address and password for regular user with logged in flash" do

        visit "/"

        click_on "Sign in"

        expect(current_path).to eq('/login')

        fill_in :email, with: @regular_user.email
        fill_in :password, with: @regular_user.password
        # how to test becrypt authentication

        click_on "Login!"

        expect(current_path).to eq('/merchant')
        
        expect(page).to have_content("Welcome, #{@regular_user.name}")
        expect(page).to have_link("Log out")
        expect(page).to have_content("You are now logged in.")
        expect(page).to_not have_link("Register")
        expect(page).to_not have_link("Sign in")
    end
end

# When I visit the login path
# I see a field to enter my email address and password
# When I submit valid information
# If I am a regular user, I am redirected to my profile page
# If I am a merchant user, I am redirected to my merchant dashboard page
# If I am an admin user, I am redirected to my admin dashboard page
# And I see a flash message that I am logged in