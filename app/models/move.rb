class Move < ActiveRecord::Base
  belongs_to :player
  belongs_to :board
end
