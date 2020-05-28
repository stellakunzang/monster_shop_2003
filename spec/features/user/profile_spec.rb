require 'rails_helper'

RSpec.describe "User profile page" do
  before(:each) do
    @regular_user = User.create(name: "Willy Wonka", address: "123 St", city: "Denver", state: "CO", zip: "12345", email: "chocolateguy1@gmail.com", password: "loco123", role: 0)
  end
  it "displays current user data and edit info link" do

    visit '/login'

    fill_in :email, with: @regular_user.email
    fill_in :password, with: @regular_user.password
    click_on "Login!"

    expect(current_path).to eq('/profile')

    expect(page).to have_content("Welcome, #{@regular_user.name}")
    expect(page).to have_link("Log out")
    expect(page).to have_content(@regular_user.name)
    expect(page).to have_content(@regular_user.email)
    expect(page).to have_content(@regular_user.address)
    expect(page).to have_content(@regular_user.city)
    expect(page).to have_content(@regular_user.state)
    expect(page).to have_content(@regular_user.zip)
    expect(page).to have_content(@regular_user.email)
    expect(page).to have_link("Edit My Profile")

    expect(page).to_not have_content(@regular_user.password)
    expect(page).to_not have_link("Sign up")
    expect(page).to_not have_link("Sign in")
  end

  it "Allows user to edit profile info" do
    visit '/login'

    fill_in :email, with: @regular_user.email
    fill_in :password, with: @regular_user.password
    click_on "Login!"

    expect(current_path).to eq('/profile')
    click_link("Edit My Profile")
    expect(current_path).to eq('/profile/edit')

    expect(page).to have_content(@regular_user.name)
    expect(page).to have_content(@regular_user.email)
    expect(page).to have_content(@regular_user.address)
    expect(page).to have_content(@regular_user.city)
    expect(page).to have_content(@regular_user.state)
    expect(page).to have_content(@regular_user.zip)
    expect(page).to have_content(@regular_user.email)

    fill_in :city, with: "Boston"
    fill_in :state, with: "MA"
    fill_in :zip, with: "12345"
    click_button("Submit")
    expect(current_path).to eq('/profile')

    expect(page).to have_content("Your data has been udpated.")
    expect(page).to have_content(@regular_user.name)
    expect(page).to have_content(@regular_user.email)
    expect(page).to have_content(@regular_user.address)
    expect(page).to have_content("Boston")
    expect(page).to have_content("MA")
    expect(page).to have_content("12345")
    expect(page).to have_content(@regular_user.email)

end


# User Story 19, User Profile Show Page
#
# As a registered user
# When I visit my profile page
# Then I see all of my profile data on the page except my password
# And I see a link to edit my profile data
