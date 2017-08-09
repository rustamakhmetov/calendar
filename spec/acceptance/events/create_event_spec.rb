require 'acceptance/acceptance_helper'

feature "User can add event", %q{
  In order to be able to remember event
  As an user
  I want to be able to save event
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user added event', js: true do
    sign_in(user)

    visit root_path
    within ".new-event" do
      fill_in 'Date', with: DateTime.now
      fill_in 'Body', with: 'new text text'
      click_on "Add"
      wait_for_ajax
    end
    expect(page).to have_content 'Event was successfully created'
    within "div#day#{Date.today.day}" do
      expect(page).to have_content 'new text text'
    end
  end

  scenario 'Authenticated user to be fill event with invalid data', js: true do
    sign_in(user)

    visit root_path
    within ".new-event" do
      fill_in 'Body', with: ''
      click_on 'Add'
      wait_for_ajax
    end
    expect(page).to have_content 'Body can\'t be blank'
  end

  #
  # context "multiple sessions" do
  #   given!(:question2) { create(:question) }
  #   scenario "answer on question appears on another user's page", js: true do
  #     Capybara.using_session('user') do
  #       sign_in user
  #       visit question_path(question)
  #       expect(page).to have_content question.title
  #       expect(page).to have_content question.body
  #     end
  #
  #     Capybara.using_session('guest') do
  #       visit question_path(question)
  #     end
  #
  #     Capybara.using_session('guest2') do
  #       visit question_path(question2)
  #     end
  #
  #     Capybara.using_session('user') do
  #       within("form.new_answer") do
  #         fill_in 'Body', with: 'text text'
  #         click_on 'Ask answer'
  #         wait_for_ajax
  #       end
  #       expect(page).to have_content 'Answer was successfully created'
  #       expect(page).to have_content 'text text'
  #     end
  #
  #     Capybara.using_session('guest') do
  #       expect(page).to have_content 'text text'
  #     end
  #
  #     Capybara.using_session('guest2') do
  #       expect(page).to_not have_content 'text text'
  #     end
  #   end
  # end

end