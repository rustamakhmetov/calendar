require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_and_belong_to_many(:events) }

  let!(:user) { create(:user) }

  describe "#create_event" do
    subject { user.create_event(Date.today, "text text") }

    it "event saved to database" do
      expect { subject }.to change(Event, :count).by(1)
    end

    it "return event" do
      event = subject
      expect(event).to be_a(Event)
      expect(event.body).to eq "text text"
      expect(event.owner).to eq user
      expect(event.users.first).to eq user
      expect(user.events.first).to eq event
    end
  end

  describe "#delete_event" do
    let(:user_dst) { create(:user) }
    let!(:event) { user.create_event(Date.today, "text text") }

    describe "as the owner" do
      it "delete event from database" do
        expect{user.delete_event(event)}.to change(Event, :count).by(-1)
      end

      it "delete shared event" do
        event.share(user_dst)
        expect{user.delete_event(event)}.to change(user_dst.events, :count).by(-1)
      end
    end

    describe "as the non-owner" do
      it "event don't delete from database" do
        event.share(user_dst)
        expect{user_dst.delete_event(event)}.to_not change(Event, :count)
      end

      it "event removed from user's event collection" do
        event.share(user_dst)
        expect{user_dst.delete_event(event)}.to change(user_dst.events, :count).by(-1)
      end
    end
  end

  describe "#events_by_date" do
    let!(:events) { 5.times.map {|i| user.create_event(Date.today, "text text #{i}")} }
    let!(:events_yesterday) { 5.times.map {|i| user.create_event(Date.yesterday, "text text #{i}")} }

    it "return array of events on date" do
      expect(user.events_by_date(Date.today)).to match_array(events)
      expect(user.events_by_date(Date.yesterday)).to match_array(events_yesterday)
    end
  end
end
