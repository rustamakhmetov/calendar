FactoryGirl.define do
  sequence(:body) do |n|
    "Body #{n}"
  end

  factory :event do
    body
  end
end
