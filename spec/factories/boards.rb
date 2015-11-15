FactoryGirl.define do
  factory :board do
    r1_c1 1
    r1_c2 0
    r1_c3 1
    r2_c1 nil
    r2_c2 1
    r2_c3 0
    r3_c1 0
    r3_c2 0
    r3_c3 0
  end

  trait :winning_combination_by_rows do

  end

  trait :winning_combination_by_columns do

  end

end