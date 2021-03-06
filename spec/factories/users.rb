FactoryGirl.define do
  sequence :email do |n|
    "e+user#{n}@varnakov.ru"
  end

  factory :user do
    email
    password '12345678'
    confirmed_at {Time.now}
  end
end
