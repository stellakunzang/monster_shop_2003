require 'rails_helper'

RSpec.describe "Logging in" do
    before(:each) do
        @admin_1 = User.create(name: "Kurt Cobain", address: "666 Lake Washington Bldv", city: "Seattle", state: "Washington", zip: "32786", email: "GrungeIsDead@gmail.com", password: "Forever27", role: 2)
    end

    it "I see a field to enter my email address and password for regular user with logged in flash" do

        visit "/"

        click_on "Sign in"

        expect(current_path).to eq('/login')

        fill_in :email, with: @admin_1.email
        fill_in :password, with: @admin_1.password
        # how to test becrypt authentication

        click_on "Login!"

        expect(current_path).to eq('/admin')

        expect(page).to have_content("Welcome, #{@admin_1.name}")
        expect(page).to have_link("Log out")
        expect(page).to have_content("You are now logged in.")
        expect(page).to_not have_link("Sign up")
        expect(page).to_not have_link("Sign in")
    end
    it "Users who are logged in already are redirected" do 

      visit "/"

      click_on "Sign in"

      fill_in :email, with: @admin_1.email
      fill_in :password, with: @admin_1.password

      click_on "Login!"
      
      expect(current_path).to eq('/admin')

      visit "/login"
      
      expect(current_path).to eq('/admin')

      expect(page).to have_content("Admin Dashboard")
      expect(page).to have_link("Log out")
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

# Questions
# A visitor should not be able to delete a merchant? in a spec given to us
# in destroy spec