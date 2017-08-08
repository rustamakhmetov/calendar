require 'acceptance/acceptance_helper'

feature 'User on dashboard', %q{
  In order to be able to manage calendar service from dashboard
  As an user
  I want to be able to manage calendar service
} do

  given(:user) { create(:user)}

  describe 'Authenticate user' do
    #let!(:courses) { create_list(:course, 10) }

    before do
      sign_in(user)
      # Dashboard.dates_week(Date.today).each do |day|
      #   menus[day] = create(:menu_item_with_courses, menu: menu, created_at: day)
      # end
    end

    scenario 'see current month on dashboard' do
      visit root_path
      expect(page).to have_content "#{Date.today.strftime('%^B')}"
      Dashboard.monthdays(Date.today).each do |date|
        expect(page).to have_css("div#day#{date.day}")
      end
    end

    # scenario 'see menu', js: true do
    #   menu = menus[Date.today]
    #   visit root_path
    #   click_on Date.today.strftime("%A")
    #   wait_for_ajax
    #   within ".menu" do
    #     menu.items.each do |item|
    #       expect(page).to have_content(item.course.name)
    #       expect(page).to have_content(item.price)
    #     end
    #   end
    # end
  end
end

