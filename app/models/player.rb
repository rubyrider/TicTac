class Player < ActiveRecord::Base
  has_many :moves

  validates :name, :presence => true
end
