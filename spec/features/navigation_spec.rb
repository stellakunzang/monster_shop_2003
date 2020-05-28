
require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    it "I see a nav bar with links to all pages" do
      visit '/merchants'

      within 'nav' do
        click_link 'All Items'
      end

      expect(current_path).to eq('/items')

      within 'nav' do
        click_link 'All Merchants'
      end

      expect(current_path).to eq('/merchants')

      within 'nav' do
        click_link 'Home'
      end

      expect(current_path).to eq('/merchants')

      within 'nav' do
        click_link 'Cart'
      end

      expect(current_path).to eq('/cart')

      within 'nav' do
        click_link 'Login'
      end

      expect(current_path).to eq('/login')

      within 'nav' do
        click_link 'Register'
      end

      expect(current_path).to eq('/register')
    end

    it "I can see a cart indicator on all pages" do
      visit '/merchants'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/items'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/cart'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/login'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/register'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end
    end
  end
  # describe "As a Default user" do
  #   it "I see all links, plus profile and logout links. I do NOT see login or register links" do
  #     visit '/merchants'
  #
  #     within 'nav' do
  #       click_link 'All Items'
  #     end
  #
  #     expect(current_path).to eq('/items')
  #
  #     within 'nav' do
  #       click_link 'All Merchants'
  #     end
  #
  #     expect(current_path).to eq('/merchants')
  #
  #     within 'nav' do
  #       click_link 'Home'
  #     end
  #
  #     expect(current_path).to eq('/merchants')
  #
  #     within 'nav' do
  #       click_link 'Cart'
  #     end
  #
  #     expect(current_path).to eq('/cart')
  #
  #     within 'nav' do
  #       click_link 'Profile'
  #     end
  #
  #     expect(current_path).to eq('/profile')
  #
  #     within 'nav' do
  #       click_link 'Logout'
  #     end
  #
  #     expect(current_path).to eq('/logout')
  #
  #     within 'nav' do
  #       expect(page).to_not have_link 'Login'
  #       expect(page).to_not have_link 'Register'
  #     end
  #
  #   end
  # end
end
