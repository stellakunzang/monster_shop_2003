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

        click_on "Login!"

        expect(current_path).to eq('/admin')

        expect(page).to have_content("Welcome, #{@admin_1.name}")
        expect(page).to have_link("Log out")
        expect(page).to have_content("You are now logged in.")
        expect(page).to_not have_link("Sign up")
        expect(page).to_not have_link("Sign in")
    end
end
