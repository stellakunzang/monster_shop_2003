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

   expect(page).to have_field(:name, :with => @regular_user.name)
   expect(page).to have_field(:address, :with => @regular_user.address)
   expect(page).to have_field(:city, :with => @regular_user.city)
   expect(page).to have_field(:state, :with => @regular_user.state)
   expect(page).to have_field(:zip, :with => @regular_user.zip)
   expect(page).to have_field(:email, :with => @regular_user.email)
   expect(page).to_not have_field(:password)

    fill_in :city, with: "Boston"
    fill_in :state, with: "MA"
    fill_in :zip, with: "12345"
    click_button("Submit")
    expect(current_path).to eq('/profile')
    expect(page).to have_content("Your data has been updated.")
    expect(page).to have_content(@regular_user.name)
    expect(page).to have_content(@regular_user.email)
    expect(page).to have_content(@regular_user.address)
    expect(@regular_user.reload.city).to eq ("Boston")

    expect(page).to have_content("Boston")
    expect(page).to have_content("MA")
    expect(page).to have_content("12345")
    expect(page).to have_content(@regular_user.email)
  end

  it "Allows user to update their password" do
    visit '/login'

    fill_in :email, with: @regular_user.email
    fill_in :password, with: @regular_user.password
    click_on "Login!"

    expect(current_path).to eq('/profile')
    click_link("Edit My Password")
    expect(current_path).to eq('/password/edit')

    fill_in :password, with: "hellokitty"
    fill_in :password_confirmation, with: "hellokitty"
    click_button("Submit")
    expect(current_path).to eq('/profile')
    expect(page).to have_content("Your password has been updated.")

  end

  it "Denies ability to update email address to one that is already in use" do
    User.create(name: "Fake Willy", address: "123 St", city: "Boulder", state: "CO", zip: "12346", email: "wannabechocolateguy1@gmail.com", password: "loco321", role: 0)

    visit '/login'

    fill_in :email, with: @regular_user.email
    fill_in :password, with: @regular_user.password
    click_on "Login!"

    expect(current_path).to eq('/profile')
    click_link("Edit My Profile")
    expect(current_path).to eq('/profile/edit')

    fill_in :email, with: "wannabechocolateguy1@gmail.com"
    click_button("Submit")

    expect(current_path).to eq('/profile/edit')
    expect(page).to have_content("Email address is already in use.")


  end

end
