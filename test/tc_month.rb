require "test/unit"

require_relative "../lib/month"

class TestMonth < Test::Unit::TestCase
  def setup
    @m = Caline::Month.new(2010, 12)
    @lasts2010 = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  end

  def test_last_day
    (1..12).each { |m| assert_equal(@lasts2010[m], Caline::Month.new(2010, m).last.day) }
  end

  def test_year_month
    assert_equal(2010, @m.year)
    assert_equal(12, @m.month)
  end

  def test_dates
    assert_equal((1..28).to_a, Caline::Month.new(2011, 2).dates.map(&:day))
    assert_equal((1..31).to_a, @m.dates.map(&:day))
  end

  def test_dates_by_week
    f2010_12_from0 = [
      [28, 29, 30, 1, 2, 3, 4],
      [5, 6, 7, 8, 9, 10, 11],
      [12, 13, 14, 15, 16, 17, 18],
      [19, 20, 21, 22, 23, 24, 25],
      [26, 27, 28, 29, 30, 31, 1]
    ]
    f2010_12_from1 = [
      [29, 30, 1, 2, 3, 4, 5],
      [6, 7, 8, 9, 10, 11, 12],
      [13, 14, 15, 16, 17, 18, 19],
      [20, 21, 22, 23, 24, 25, 26],
      [27, 28, 29, 30, 31, 1, 2]
    ]
    assert_equal(f2010_12_from0, @m.dates_by_week.map{ |w| w.map(&:day) })
    assert_equal(f2010_12_from1, @m.dates_by_week(1).map{ |w| w.map(&:day) })
  end

  def test_format
    puts
    puts @m.format
    puts
    puts @m.format(:week, 1)
    puts
    puts @m.format(:month)
  end
  
  def test_color_format
    puts @m.color_format(:week, 0)
    puts @m.color_format(:week, 1)
    puts @m.color_format(:month, 1)
  end
  
  def test_colors
    m = Caline::Month.new(2011, 2, sunday: :yellow, saturday: :green)
    puts
    puts m.color_format(:week, 0)
    m.colors = {sunday: :red, saturday: :blue}
    puts m.color_format(:month, 1)
  end

  def test_holidays
    months = (1..12).map { |m| Caline::Month.new(2011, m) }
    months.each do |mon|
      mon.holidays
      puts
      puts mon.color_format
    end
  end
end
