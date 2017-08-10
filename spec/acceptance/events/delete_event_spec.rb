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
    let!(:user_dst) { create(:user) }

    scenario "remove shared event", js: true do
      event.share(user_dst)
      sign_in(user_dst)

      visit root_path
      event_css = "#event#{event.id}"
      within event_css do
        click_on "Delete"
      end
      expect(page).to have_content 'Event was successfully destroyed.'
      expect(current_path).to eq root_path
      expect(page).to_not have_selector(event_css)
    end
  end
  # scenario 'Authenticated author can not delete other answer', js: true do
  #   sign_in(user)
  #
  #   answer = create(:answer, user: create(:user), question: question)
  #   visit question_path(question)
  #   within "#answer#{answer.id}" do
  #     expect(page).to_not have_link "Delete"
  #   end
  # end
  #
  # scenario 'Non-authenticated user can not delete answers', js: true do
  #   visit question_path(question)
  #   question.answers.each do |answer|
  #     within "#answer#{answer.id}" do
  #       expect(page).to_not have_link "Delete"
  #     end
  #   end
  # end

end