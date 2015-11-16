class PointTablePresenter

  attr_reader :source
  attr_reader :winner
  attr_reader :looser

  def initialize(source)
    @source = source
    @winner = source.winner
    @looser = source.looser
  end

  def winner_name
    winner.present? ? winner.name : '-'
  end

  def looser_name
    looser.present? ? looser.name : '-'
  end

  def result
    source.result || '-'
  end
end