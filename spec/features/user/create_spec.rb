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

    expect(page).to have_content("Welcome, George!")
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
    expect(page).to have_content("Welcome, George!")
  end

  it "will not create user with incorrect info" do

    User.create(name: "Cardi", address: '123 Dog Rd.', city: 'Denver', state: 'CO', zip: 80204, email: 'coronavirusitsgettingreal@gmail.com', password: "iloveoffset")


    visit "/register"

    email =  "georgef@gmail.com"
    password = "grillingiscool"

    fill_in :name, with: "George"
    fill_in :address, with: "3 Main st."
    fill_in :state, with: "MA"
    fill_in :city, with: "Boston"
    fill_in :zip, with: "12345"
    fill_in :email, with: 'coronavirusitsgettingreal@gmail.com'
    fill_in :password, with: password
    click_on "Create User"

    expect(page).to have_content("Email has already been taken")

    fill_in :name, with: "George"
    fill_in :address, with: "3 Main st."
    fill_in :state, with: "MA"
    fill_in :city, with: "Boston"
    fill_in :zip, with: "12345"
    fill_in :email, with: email
    fill_in :password, with: password
    click_on "Create User"

    expect(current_path).to eq("/profile")
    expect(page).to have_content("Welcome, George!")
  end
end
