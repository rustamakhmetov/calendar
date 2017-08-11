require 'acceptance/acceptance_helper'

feature 'Share event', %q{
  In order to be able to share information
  As an user
  I want to be able to share an event
} do

  given!(:user) { create(:user) }
  given!(:user1) { create(:user) }
  given!(:event) { user.create_event(Date.today, "text text") }

  describe 'Owner' do

    context "single session" do
      before do
        sign_in user
        visit root_path
      end

      scenario 'see share link' do
        within "div#day#{event.date.day}" do
          expect(page).to have_link('Share')
        end
      end

      scenario 'share event on existing email', js: true do
        within "#event#{event.id}" do
          expect(page).to_not have_selector("form.share_event")
          click_on 'Share'
          expect(page).to_not have_link('Share')
          expect(page).to have_selector("form.share_event")
          fill_in 'Email', with: user1.email
          click_on 'Send'
          expect(page).to_not have_selector("form.share_event")
          expect(page).to have_link('Share')
          expect(page).to_not have_content(user1.email)
        end
        expect(page).to have_content("Event was successfully shared.")
      end

      scenario 'share event on non-existing email', js: true do
        within "#event#{event.id}" do
          expect(page).to_not have_selector("form.share_event")
          click_on 'Share'
          expect(page).to_not have_link('Share')
          expect(page).to have_selector("form.share_event")
          fill_in 'Email', with: ""
          click_on 'Send'
          expect(page).to have_selector("form.share_event")
          expect(page).to_not have_link('Share')
          expect(page).to have_content("User not exists")
        end
      end
    end

    context "multiple sessions" do
      scenario "shared event appears on another user's page", js: true do
        Capybara.using_session('user') do
          sign_in user
          visit root_path
          within "#event#{event.id}" do
            click_on 'Share'
            wait_for_ajax
            fill_in 'Email', with: user1.email
            click_on 'Send'
            wait_for_ajax
          end
        end

        Capybara.using_session('user1') do
          sign_in user1
          visit root_path
          within "#event#{event.id}" do
            expect(page).to have_content(event.body)
          end
        end
      end
    end
  end

  describe 'Non-owner' do
    before do
      sign_in user1
      event.share(user1)
      visit root_path
    end

    scenario "don't see share link" do
      within "div#day#{event.date.day}" do
        expect(page).to_not have_link('Share')
      end
    end
  end
end