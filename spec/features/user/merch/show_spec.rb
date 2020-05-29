require 'rails_helper'

RSpec.describe "Merchant employee dashboard show page" do

  before(:each) do
    @dog_shop = Merchant.create(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203)
    @maude = dog_shop.users.create(name: "Maude Sloggett", address: "17 Sun Rise St", city: "El Paso", state: "Illinois", zip: "56726", email: "M.Slogget@yahoo.com", password: "Forever27", role: 1, merchant_id: dog_shop.id)

    visit '/login'
    fill_in :email, with: @maude.email
    fill_in :password, with: @maude.password
    click_on "Login!"
  end

  it "displays name and address of merchant employer" do

    visit '/merchant'

    expect(page).to have_content(@dog_shop.name)
    expect(page).to have_content(@dog_shop.address)
    expect(page).to have_content(@dog_shop.city)
    expect(page).to have_content(@dog_shop.state)
    expect(page).to have_content(@dog_shop.zip)
    
  end
end
