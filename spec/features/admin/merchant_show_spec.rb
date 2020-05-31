require 'rails_helper'

RSpec.describe "Admin view of merchant dashboard" do

  before(:each) do
    @dog_shop = Merchant.create!(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203)
    @admin = User.create!(name: "Maude Sloggett", address: "17 Sun Rise St", city: "El Paso", state: "Illinois", zip: "56726", email: "M.Slogget@yahoo.com", password: "Forever27", role: 2)
    @pull_toy = Item.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32, merchant_id: @dog_shop.id)
    @dog_bone = Item.create!(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 21, merchant_id: @dog_shop.id)

    visit '/login'
    fill_in :email, with: @admin.email
    fill_in :password, with: @admin.password
    click_on "Login!"
  end

  xit "merchant index page links to show page" do

    visit "/merchants"
    click_on @dog_shop.name
    expect(current_path).to eq("/admin/merchants/#{@dog_shop.id}")
  end

  it "merchant show page displays content it would for merchant" do

    visit "/admin/merchants/#{@dog_shop.id}"

    expect(page).to have_content(@dog_shop.name)
    expect(page).to have_content(@dog_shop.address)
  end

end
