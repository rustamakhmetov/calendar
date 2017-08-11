FactoryGirl.define do
  sequence(:body) do |n|
    "Body #{n}"
  end

  factory :event do
    body
  end

  factory :invalid_event, class: "Event" do
    body nil
  end
end
