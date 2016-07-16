FactoryGirl.define do
  factory :question_rating, class: 'Rating' do
    user
    association :rateable, factory: :question
    rate 1
  end

  factory :answer_rating, class: 'Rating' do
    user
    association :rateable, factory: :answer
    rate 1
  end
end
