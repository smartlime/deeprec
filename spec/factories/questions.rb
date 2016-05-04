FactoryGirl.define do
  factory :question do
    topic 'Sample Topic of a Question'
    body 'Lorem ipsum dolor sit amet, consectetur adipiscing elit'
    rating 0
  end

  factory :invalid_question, class: "Question" do
    topic nil
    body nil
    rating nil
  end
end
