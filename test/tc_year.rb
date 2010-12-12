require "test/unit"

require_relative "../lib/year"

class TestYear < Test::Unit::TestCase
  def setup
    @y2010 = Caline::Year.new(2010)
  end
  def test_holidays
    @y2010.holidays = :ja_ja
  end

  def test_format
    puts @y2010.format
  end
end