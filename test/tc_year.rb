require "test/unit"

require_relative "../lib/year"

class TestYear < Test::Unit::TestCase
  def setup
    @y2010 = Caline::Year.new(2010)
  end

  def test_format_with_weekline
    puts @y2010.format(:week, 1)
    puts @y2010.color_format(:week)
  end

  def test_fromat_with_monthline
    puts @y2010.format(:month)
    puts @y2010.color_format(:month, 1)
  end

  def test_color_options
    cal = Caline::Year.new(2010, today:[:red, :blink, :on_blue], year: :magenta)
    puts cal.color_format
  end

  def test_neighbor_option
    cal = Caline::Year.new(2009, neighbor: :black)
    puts cal.color_format
  end

  def test_holidays_option
    cal = Caline::Year.new(2012, holidays: :us)
    puts cal.color_format
  end
end