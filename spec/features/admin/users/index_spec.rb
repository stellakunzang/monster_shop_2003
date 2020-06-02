require 'rails_helper'

RSpec.describe "Admin view of user index page" do
  before(:each) do
    login_admin
    @user = User.create(name: "Willy Wonka", address: "123 St", city: "Denver", state: "CO", zip: "12345", email: "chocolateguy1@gmail.com", password: "loco123", role: 0)
    @user2 = User.create(name: "Turkey Wonka", address: "123 St", city: "Denver", state: "CO", zip: "12345", email: "chocolategoy@gmail.com", password: "locate123", role: 1)
  end

  it "displays all users" do

    visit "/admin/users"

    expect(page).to have_content(@user.name)
    expect(page).to have_content(@user.created_at)
    expect(page).to have_content(@user.role)

    expect(page).to have_content(@user2.name)
    expect(page).to have_content(@user2.created_at)
    expect(page).to have_content(@user2.role)
  end

  it "user name is a link to user's profile" do
    visit "/admin/users"

    click_link "#{@user.name}"

    expect(current_path).to eq("/admin/profile/#{@user.id}")
  end

end
