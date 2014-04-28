class TestPage
  attr_accessor :world

  def initialize(world)
    self.world = world
  end

  delegate :page, to: :world
end