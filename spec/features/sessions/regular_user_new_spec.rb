require 'rails_helper'

RSpec.describe "Logging in" do
    before(:each) do
        @regular_user = User.create(name: "Willy Wonka", address: "123 St", city: "Denver", state: "CO", zip: "12345", email: "chocolateguy1@gmail.com", password: "loco123", role: 0)
    end

    it "I see a field to enter my email address and password for regular user with logged in flash" do

        visit "/"

        click_on "Sign in"

        expect(current_path).to eq('/login')

        fill_in :email, with: @regular_user.email
        fill_in :password, with: @regular_user.password
        # how to test becrypt authentication

        click_on "Login!"

        expect(current_path).to eq('/profile')

        expect(page).to have_content("Welcome, #{@regular_user.name}")
        expect(page).to have_link("Log out")
        expect(page).to have_content("You are now logged in.")
        expect(page).to_not have_link("Sign up")
        expect(page).to_not have_link("Sign in")
    end
    it "I submit invalid information, redirected to the login page with flash" do 

        visit "/"

        click_on "Sign in"

        expect(current_path).to eq('/login')

        fill_in :email, with: "email@lol.com"
        fill_in :password, with: "passwordtest"

        click_on "Login!"
        expect(current_path).to eq('/login')

        expect(page).to have_content("Sorry, your credentials were incorrect.")
    end
    it "Users who are logged in already are redirected" do 

        visit "/"

        click_on "Sign in"

        fill_in :email, with: @regular_user.email
        fill_in :password, with: @regular_user.password

        click_on "Login!"
        
        expect(current_path).to eq('/profile')

        visit "/login"
        
        expect(current_path).to eq('/profile')

        expect(page).to have_content("Welcome, #{@regular_user.name}")
        expect(page).to have_link("Log out")
        expect(page).to_not have_link("Sign up")
        expect(page).to_not have_link("Sign in")
    end
end


# As a registered user, merchant, or admin
# When I visit the login path
# If I am a regular user, I am redirected to my profile page
# If I am a merchant user, I am redirected to my merchant dashboard page
# If I am an admin user, I am redirected to my admin dashboard page
# And I see a flash message that tells me I am already logged in

# User Story 14

# When I visit the login page ("/login")
# And I submit invalid information
# Then I am redirected to the login page
# And I see a flash message that tells me that my credentials were incorrect
# I am NOT told whether it was my email or password that was incorrect

# When I visit the login path
# I see a field to enter my email address and password
# When I submit valid information
# If I am a regular user, I am redirected to my profile page
# If I am a merchant user, I am redirected to my merchant dashboard page
# If I am an admin user, I am redirected to my admin dashboard page
# And I see a flash message that I am logged in
