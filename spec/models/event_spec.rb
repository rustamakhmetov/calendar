require 'rails_helper'

RSpec.describe Event, type: :model do
  it { should have_one(:owner) }
  it { should have_and_belong_to_many(:users) }
  it { should validate_presence_of :body }
  it { should validate_presence_of :owner }

  describe "#share" do
    let!(:user_src) { create(:user) }
    let!(:user_dst) { create(:user) }
    let!(:event) { user_src.create_event(Date.today, "text text") }

    it "add event to user_dst" do
      event.share(user_dst)
      expect(user_dst.events.first).to eq event
    end

    it "can not share event twice with the same user" do
      expect {2.times {event.share(user_dst)} }.to change(user_dst.events, :count).by(1)
    end
  end
end
