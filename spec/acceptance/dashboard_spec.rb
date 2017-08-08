require 'acceptance/acceptance_helper'

feature 'User on dashboard', %q{
  In order to be able to manage calendar service from dashboard
  As an user
  I want to be able to manage calendar service
} do

  given(:user) { create(:user)}

  describe 'Authenticate user' do
    let!(:events) { 5.times.map { |i| user.create_event(Date.today, "Body #{i}") }}

    before { sign_in(user) }

    scenario 'see current month on dashboard' do
      visit root_path
      expect(page).to have_content "#{Date.today.strftime('%^B')}"
      Dashboard.monthdays(Date.today).each do |date|
        expect(page).to have_css("div#day#{date.day}")
      end
    end

    scenario 'see events on dashboard' do
      visit root_path
      within "div#day#{Date.today.day}" do
        events.each do |event|
          expect(page).to have_content event.body
        end
      end
    end
  end
end

