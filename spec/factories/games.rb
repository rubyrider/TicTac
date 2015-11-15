FactoryGirl.define do
  factory :game do
    status Game::NOT_STARTED
    started_at nil
    abandoned_at nil
    player
    opponent
  end

  trait :running do
    started_at { Time.zone.now }
    status Game::RUNNING
  end

  trait :abondon do
    status Game::ABANDONED
    abondoned_at { Time.zone.now }
  end
end