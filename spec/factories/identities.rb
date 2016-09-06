FactoryGirl.define do
  sequence :uid do |n|
    "#{Time.now.to_i}-#{Faker::Lorem.word}-#{n}"
  end

  sequence :provider do |n|
    "deeprec-provider-#{n}"
  end

  factory :identity do
    user
    provider
    uid
  end

  factory :invalid_identity, class: 'Identity' do
    user nil
    provider nil
    uid nil
  end
end
