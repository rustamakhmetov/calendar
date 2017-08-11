require 'rails_helper'

RSpec.describe Event, type: :model do
  it { should have_one(:owner) }
  it { should have_many(:users).through(:shares) }
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

  describe "#share_by_email" do
    let!(:user_src) { create(:user) }
    let!(:user_dst) { create(:user) }
    let!(:event) { user_src.create_event(Date.today, "text text") }

    describe "with valid attributes" do
      it "add event to user_dst event's collection" do
        event.share_by_email(user_dst.email)
        expect(user_dst.events.first).to eq event
      end
    end

    describe "with invalid attributes" do
      it "return error message" do
        [nil, "", "unknow@test.com"].each do |email|
          event.errors.clear
          event.share_by_email(email)
          expect(event.errors.full_messages).to eq ["User not exists"]
        end
      end
    end
  end
end
