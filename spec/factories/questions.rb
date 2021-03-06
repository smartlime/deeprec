FactoryGirl.define do
  factory :question do
    user
    topic { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph(4, true, 8) }
  end

  factory :invalid_question, class: 'Question' do
    user nil
    topic nil
    body nil
  end
end
