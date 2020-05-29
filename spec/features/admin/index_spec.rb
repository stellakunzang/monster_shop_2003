require 'rails_helper'

RSpec.describe "Admin from their index page (/admin/merchants)" do
  it "displays all merchants with functioning buttons to disable and enable merchants" do
    merch1 = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    merch2 = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    merch2.update_attribute(:active?, false)
    merch3 = Merchant.create(name: "Mikes House", address: '23 Just Do It Blvd.', city: 'Denver', state: 'CO', zip: 80208)

    visit "/admin/merchants"

    within ".merchant-#{merch1.id}" do
      click_link "disable"
      expect(current_path).to eq("/admin/merchants")
      expect(page).to_not have_link("disable")
      expect(page).to have_link("enable")
    end

    expect(page).to have_content("disabled #{merch1.name}")

    within ".merchant-#{merch2.id}" do
      click_link "enable"
      expect(current_path).to eq("/admin/merchants")
      expect(page).to have_link("disable")
      expect(page).to_not have_link("enable")
    end

    expect(page).to have_content("enabled #{merch2.name}")

    within ".merchant-#{merch3.id}" do
      click_link "disable"
      expect(current_path).to eq("/admin/merchants")
      expect(page).to_not have_link("disable")
    end

    expect(page).to have_content("disabled #{merch3.name}")
  end
end
