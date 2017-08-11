require 'rails_helper'

RSpec.describe Dashboard, type: :model do
  describe ".weekdays" do
    it 'return array of days' do
      expect(Dashboard.weekdays).to match_array(%w{Monday Tuesday Wednesday Thursday Friday Saturday Sunday})
    end
  end

  describe ".monthdays" do
    it 'return array of days' do
      current_day = Date.today
      month = Dashboard.monthdays(current_day).to_a
      expect(month.first).to eq current_day.beginning_of_month
      expect(month.last).to eq current_day.end_of_month
      expect(month.count).to eq Time.days_in_month(current_day.month)
    end
  end
end
