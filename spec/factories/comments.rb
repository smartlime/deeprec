FactoryGirl.define do
  factory :comment do
    user
    body { Faker::Lorem.paragraph(4, true, 8) }
  end

  factory :invalid_comment, class: 'Comment' do
    user nil
    body nil
  end
end
