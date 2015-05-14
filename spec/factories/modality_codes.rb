FactoryGirl.define do
  sequence :code do |n|
    100 + n
  end

  factory :modality_code do
    code
    name 'CAPD (disconnect)'

    trait :capd_standard do
      name 'CAPD (standard)'
    end
    trait :ccpd_6_nights do
      name 'CCPD (<6 nights/wk)'
    end
    trait :death do
      name 'Death'
    end
  end
end