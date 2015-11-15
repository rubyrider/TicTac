FactoryGirl.define do
  factory :game do
    status Game::NOT_STARTED
    started_at nil
    abandoned_at nil
    player
    opponent

    transient do
      winning_game false
    end

    after(:create) do |game, evaluator|
      if evaluator.winning_game
        player = game.player
        opponent = game.opponent
        game.start!
        game.move!({player_id: player.id, x_axis: 2, y_axis: 1})
        game.move!({player_id: opponent.id, x_axis: 3, y_axis: 1})
        game.move!({player_id: player.id, x_axis: 2, y_axis: 2})
        game.move!({player_id: opponent.id, x_axis: 3, y_axis: 3})
        game.move!({player_id: player.id, x_axis: 2, y_axis: 3})
      end
    end
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