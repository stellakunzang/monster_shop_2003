require 'rails_helper'

RSpec.describe "Admin from their index page (/admin/merchants)" do
  before(:each) do
    @merchant1 = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @merchant2 = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    @merchant2.update_attribute(:active?, false)
    @merchant3 = Merchant.create(name: "Mikes House", address: '23 Just Do It Blvd.', city: 'Denver', state: 'CO', zip: 80208)
    @item1 = @merchant1.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
    @item2 = @merchant2.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: true, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)
    @item3 = @merchant3.items.create(name: "Handle Bar Tassels", description: "WEEEEeee!!!", active?: true, price: 15, image: "https://images.freeimages.com/images/large-previews/0ba/i-love-pasta-1-1566263.jpg", inventory: 6)
    @item4 = @merchant3.items.create(name: "Bike Seat", description: "Not for human consumption!", active?: true, price: 105, image: "https://media.istockphoto.com/photos/close-loose-toilet-seat-and-lid-isolated-on-white-picture-id598567074", inventory: 3)
  end
  it "displays all merchants with functioning buttons to disable and enable merchants" do

    visit "/admin/merchants"

    within ".merchant-#{@merchant1.id}" do
      click_link "disable"
      expect(current_path).to eq("/admin/merchants")
      expect(page).to_not have_link("disable")
      expect(page).to have_link("enable")
    end

    expect(page).to have_content("disabled #{@merchant1.name}")

    within ".merchant-#{@merchant2.id}" do
      click_link "enable"
      expect(current_path).to eq("/admin/merchants")
      expect(page).to have_link("disable")
      expect(page).to_not have_link("enable")
    end

    expect(page).to have_content("enabled #{@merchant2.name}")

    within ".merchant-#{@merchant3.id}" do
      click_link "disable"
      expect(current_path).to eq("/admin/merchants")
      expect(page).to_not have_link("disable")
    end

    expect(page).to have_content("disabled #{@merchant3.name}")
  end

  it "enables and disables items belonging to an altered merchant" do

    visit "/items/#{@item3.id}"
    expect(page).to have_content("Active")

    visit "/admin/merchants"

    within ".merchant-#{@merchant3.id}" do
      click_link "disable"
      expect(current_path).to eq("/admin/merchants")
      expect(page).to_not have_link("disable")
      expect(page).to have_link("enable")
    end

    visit "/items/#{@item3.id}"
    expect(page).to have_content("Inactive")

    visit "/items/#{@item4.id}"
    expect(page).to have_content("Inactive")

    visit "/admin/merchants"

    within ".merchant-#{@merchant3.id}" do
      click_link "enable"
      expect(current_path).to eq("/admin/merchants")
      expect(page).to_not have_link("enable")
      expect(page).to have_link("disable")
    end

    visit "/items/#{@item3.id}"

    expect(page).to have_content("Active")

    visit "/admin/merchants"

    visit "/items/#{@item4.id}"
    expect(page).to have_content("Active")
  end

  it "can see all merchants in the system" do
    visit "/admin/merchants"
    
    expect(page).to have_content(@merchant1.name)
    expect(page).to have_content(@merchant1.city)
    expect(page).to have_content(@merchant1.state)

    expect(page).to have_content(@merchant2.name)
    expect(page).to have_content(@merchant2.city)
    expect(page).to have_content(@merchant2.state)

    expect(page).to have_content(@merchant3.name)
    expect(page).to have_content(@merchant3.city)
    expect(page).to have_content(@merchant3.state)

    click_link "#{@merchant1.name}"

    expect(current_path).to eq("/admin/merchants/#{@merchant1.id}")
  end
end
