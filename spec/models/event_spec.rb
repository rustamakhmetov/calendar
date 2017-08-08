require 'rails_helper'

RSpec.describe Event, type: :model do
  it { should have_one(:owner) }
  it { should have_and_belong_to_many(:users) }
end
