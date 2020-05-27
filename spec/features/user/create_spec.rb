require 'rails_helper'

RSpec.describe "User registration form" do
  it "creates new user" do

    # click_on "Register as a User"
    # expect(current_path).to eq("/register")

    visit "/register"


    email =  "georgef@gmail.com"
    password = "grillingiscool"


    fill_in :name, with: "George"
    fill_in :street_address, with: "3 Main st."
    fill_in :city, with: "Boston"
    fill_in :state, with: "MA"
    fill_in :zipcode, with: "12345"
    fill_in :email, with: email
    fill_in :password, with: password
    fill_in :confirm_password, with: password

    click_on "Create User"

    expect(current_path).to eq("/profile")
    expect(page).to have_content("Welcome, #{:name}!")
  end


  xit "will not create user with incorrect info" do

    email =  "georgef@gmail.com"
    password = "grillingiscool"

    fill_in :name, with: "George"
    fill_in :street_address, with: "3 Main st."
    fill_in :city, with: "Boston"
    fill_in :state, with: "MA"
    fill_in :zipcode, with: "12345"
    fill_in :email, with: email
    fill_in :password, with: bad_password
    fill_in :confirm_password, with: bad_password
    click_on "Create User"


    fill_in :name, with: "George"
    fill_in :street_address, with: "3 Main st."
    fill_in :city, with: "Boston"
    fill_in :state, with: "MA"
    fill_in :zipcode, with: "12345"
    fill_in :email, with: "georgeofthejungle@gmail.com"
    fill_in :password, with: password
    fill_in :confirm_password, with: password

    click_on "Create User"

    expect(current_path).to eq("/profile")
    expect(page).to have_content("Welcome, #{:name}!")
  end
end
