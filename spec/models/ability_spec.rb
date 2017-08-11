require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user)}

  describe "for guest" do
    let(:user) { nil }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }
  end

  describe "for admin" do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all}
  end

  describe "for user" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:owner_event) { user.create_event(Date.today, "text text") }
    let(:non_owner_event) { create(:user).create_event(Date.today, "text text") }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Event }

    it { should be_able_to :edit, owner_event }
    it { should be_able_to :update, owner_event }
    it { should be_able_to :destroy, owner_event }
    it { should be_able_to :share, owner_event }

    it { should_not be_able_to :edit, non_owner_event }
    it { should_not be_able_to :update, non_owner_event }
    it { should_not be_able_to :destroy, non_owner_event }
    it { should_not be_able_to :share, non_owner_event }

    it { should be_able_to :index, Dashboard }
  end
end