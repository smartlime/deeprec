FactoryGirl.define do
  factory :question do
    topic Faker::Lorem.sentence
    body Faker::Lorem.paragraph(4, true, 8)
    rating 0
    user
  end

  factory :invalid_question, class: 'Question' do
    topic nil
    body nil
    rating nil
    user nil
  end
end
