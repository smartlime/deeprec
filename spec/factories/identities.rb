FactoryGirl.define do
  factory :identity do
    user
    provider 'deeprec'
    uid 'eehieWijeshingaet8ch'
  end

  factory :alt_identity, class: 'Identity' do
    user
    provider 'theotherprovider'
    uid 'dengahpo4tae8Iew1eem'
  end

  factory :invalid_identity, class: 'Identity' do
    user nil
    provider nil
    uid nil
  end
end
