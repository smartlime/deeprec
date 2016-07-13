FactoryGirl.define do
  factory :answer do
    user
    question
    body { Faker::Lorem.paragraph(4, true, 8) }
  end

  factory :invalid_answer, class: 'Answer' do
    user nil
    question nil
    body nil
  end
end
