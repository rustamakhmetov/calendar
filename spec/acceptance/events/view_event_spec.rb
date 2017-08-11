require 'acceptance/acceptance_helper'

feature 'View event', %q{
  In order to be able to view information
  As an user
  I want to be able to view an event
} do

  given!(:user) { create(:user) }
  given!(:user1) { create(:user) }
  given!(:event) { user.create_event(Date.today, "text text") }

  describe 'Owner' do
    before do
      sign_in user
      visit root_path
    end

    scenario "don't see share link" do
      within "div#day#{event.date.day}" do
        expect(page).to_not have_link('View')
      end
    end
  end

  describe 'Non-owner' do
    before do
      sign_in user1
      event.share(user1)
      visit root_path
    end

    scenario "see view link" do
      within "div#day#{event.date.day}" do
        expect(page).to have_link('View')
      end
    end

    scenario 'viewed event', js: true do
      within "#event#{event.id}" do
        click_on 'View'
        expect(page).to_not have_link('View')
      end
      expect(page).to have_content("Event was successfully viewed.")
    end
  end
end