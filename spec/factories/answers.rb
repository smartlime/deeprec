FactoryGirl.define do
  factory :answer do
    question nil
    body 'Sed porttitor vulputate nisl, vel sagittis metus vestibulum et'
    rating 0
    user
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    rating nil
    user nil
  end
end
