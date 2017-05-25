FactoryGirl.define do
  factory :answer do
    body { Faker::Lorem.sentence }
    question
    user
  end

  factory :invalid_answer, class: "Answer" do
    body nil
    question
    user
  end
end
