require 'rails_helper'

RSpec.describe "User registration form" do
  it "creates new user" do

    # click_on "Register as a User"
    # expect(current_path).to eq("/register")

    visit "/register"


    email =  "georgef@gmail.com"
    password = "grillingiscool"


    fill_in :name, with: "George"
    fill_in :address, with: "3 Main st."
    fill_in :city, with: "Boston"
    fill_in :state, with: "MA"
    fill_in :zip, with: "12345"
    fill_in :email, with: email
    fill_in :password, with: password

    click_on "Create User"

    expect(current_path).to eq("/profile")

    expect(page).to have_content("Welcome, George! You are now registered, and logged in.")
  end


  it "will not create user with missing info" do

    visit "/register"

    email =  "georgef@gmail.com"
    password = "grillingiscool"

    fill_in :name, with: "George"
    fill_in :address, with: "3 Main st."
    fill_in :state, with: "MA"
    fill_in :zip, with: "12345"
    fill_in :email, with: email
    fill_in :password, with: password
    click_on "Create User"

    expect(page).to have_content("City can't be blank")

    fill_in :name, with: "George"
    fill_in :address, with: "3 Main st."
    fill_in :state, with: "MA"
    fill_in :city, with: "Boston"
    fill_in :zip, with: "12345"
    fill_in :email, with: email
    fill_in :password, with: password
    click_on "Create User"

    expect(current_path).to eq("/profile")
    expect(page).to have_content("Welcome, George! You are now registered, and logged in.")
    save_and_open_page
  end
end
