require 'acceptance/acceptance_helper'

feature "User sign out", %q{
  In order to be able to finish the work with the system
  As an authenticated user
  I want to be able to sign out
} do

  given(:user) { create(:user) }

  scenario 'Registered user try to sign out' do
    sign_in(user)

    visit root_path
    click_on 'Log out'

    expect(page).to have_content 'You need to sign in or sign up before continuing'
    expect(current_path).to eq new_user_session_path
  end

  scenario 'An unregistered user attempts to log out of the system' do
    visit root_path
    expect(page).to_not have_content 'Log out'
  end

end