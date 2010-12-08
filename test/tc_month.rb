require "test/unit"

require_relative "../lib/month"

class TestMonth < Test::Unit::TestCase
  def setup
    @m = Month.new(2010, 12)
    @lasts2010 = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  end

  def test_last_day
    (1..12).each { |m| assert_equal(@lasts2010[m], Month.new(2010, m).last_day) }
  end

  def test_days
    assert_equal((1..28).to_a, Month.new(2011, 2).days)
    assert_equal((1..31).to_a, @m.days)
  end

  def test_weekday
    wds = {start: 3, last: 5, 20 => 1, 1 => 3}
    wds.each { |k, v| assert_equal(v, @m.wd(k)) }
  end

  def test_year_month
    assert_equal(2010, @m.year)
    assert_equal(12, @m.mon)
  end

  def test_this_month?
    assert(@m.this_month?, "Failure message.")
    assert(!Month.new(2010, 11).this_month?, "Failure message.")
    assert(!Month.new(2011, 12).this_month?, "Failure message.")
  end

  def test_format
    f0 = " 1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 "
    f1 = "28 29 30  1  2  3  4\n 5  6  7  8  9 10 11\n12 13 14 15 16 17 18\n19 20 21 22 23 24 25\n26 27 28 29 30 31  1\n"
    f2 = "29 30  1  2  3  4  5\n 6  7  8  9 10 11 12\n13 14 15 16 17 18 19\n20 21 22 23 24 25 26\n27 28 29 30 31  1  2\n"
    assert_equal(f0, @m.format(0, false, false)) #from sunday, monthly, nofill
    assert_equal(f1, @m.format) #from sunday, weekly
    assert_equal(f2, @m.format(1)) #from monday, weekly
    assert_equal(f1.gsub("\n", " "), @m.format(0, false)) #from sunday, monthly
  end

end
