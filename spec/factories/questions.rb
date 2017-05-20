FactoryGirl.define do
  factory :question do
    title "MyString"
    body "MyText"
    factory :question_with_answer do
      after(:create) do |question|
        create(:answer,question_id: question)
      end
    end
  end


  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
end
