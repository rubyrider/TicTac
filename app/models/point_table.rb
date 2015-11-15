class PointTable < ActiveRecord::Base
  belongs_to :game
  belongs_to :winner, class_name: 'Player', foreign_key: :winner_id
  belongs_to :looser, class_name: 'Player', foreign_key: :looser_id
end
