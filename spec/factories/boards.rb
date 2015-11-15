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
    r3_c3 nil
  end

  # ----------------------------
  # |  r3_c1 | r3_c2 | r3_c3    |
  # ----------------------------
  # |  r2_c1 | r2_c2 | r2_c3    |
  # ----------------------------
  # |  r1_c1 | r1_c2 | r1_c3    |
  # ----------------------------

  trait :winning_combination_by_rows do
    r1_c1 1
    r1_c2 1
    r1_c3 1
  end

  trait :winning_combination_by_columns do
    r1_c1 1
    r2_c1 1
    r3_c1 1
  end

  trait :winning_combination_by_diagonals do
    r3_c3 1
  end

end