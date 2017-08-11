require 'acceptance/acceptance_helper'

feature 'Delete event', %q{
  In order to be able to remove my event
  As an user
  I want to be able to remove my event
} do

  given(:user) { create(:user) }
  given!(:event) { user.create_event(Date.today, "text text") }

  scenario 'Owner delete your event', js: true do
    sign_in(user)

    visit root_path
    event_css = "#event#{event.id}"
    within event_css do
      click_on "Delete"
    end
    expect(page).to have_content 'Event was successfully destroyed.'
    expect(current_path).to eq root_path
    expect(page).to_not have_selector(event_css)
  end

  describe "Non-owner" do
    given!(:user1) { create(:user) }
    given!(:event) { user.create_event(Date.today, "text text") }

    before do
      event.share(user1)
      sign_in user1
      visit root_path
    end

    scenario "don't see delete link" do
      within "div#day#{event.date.day}" do
        expect(page).to_not have_link('Delete')
      end
    end
  end
end