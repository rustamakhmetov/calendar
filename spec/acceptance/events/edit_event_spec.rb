require 'acceptance/acceptance_helper'

feature 'Edit event', %q{
  In order to be able to change information
  As an user
  I want to be able to edit an event
} do

  given!(:user) { create(:user) }

  describe 'Owner' do
    given!(:event) { user.create_event(Date.today, "text text") }

    before do
      sign_in user
      visit root_path
    end

    scenario 'see edit link' do
      within "div#day#{event.date.day}" do
        expect(page).to have_link('Edit')
      end
    end

    scenario 'edit event', js: true do
      within "#event#{event.id}" do
        expect(page).to_not have_selector("form.edit_event")
        click_on 'Edit'
        expect(page).to_not have_link('Edit')
        expect(page).to have_selector("form.edit_event")
        fill_in 'Body', with: 'new event'
        click_on 'Save'
        expect(page).to_not have_selector("form.edit_event")
        expect(page).to have_link('Edit')
        expect(page).to_not have_content(event.body)
        expect(page).to have_content('new event')
      end
    end
  end

  describe "Non-owner" do
    given!(:user1) { create(:user) }
    given!(:event) { user.create_event(Date.today, "text text") }

    before do
      event.share(user1)
      sign_in user1
      visit root_path
    end

    scenario "don't see edit link" do
      within "div#day#{event.date.day}" do
        expect(page).to_not have_link('Edit')
      end
    end
  end
end