require "test/unit"

require_relative "../lib/gcalendar"

class TestLibGcalendar < Test::Unit::TestCase
  def test_holidays_for_a_month
    gc = GCalendar.new(2010, 12)
    assert_equal(23, gc.holidays.keys[0].day)
  end

  def test_holidays_for_a_year
    gc = GCalendar.new(2010)
    puts holidays_ja = gc.holidays.map { |k, v| "#{k.strftime("%m/%d")} => #{v}" }
    puts holidays_us = gc.holidays(:us).map { |k, v| "#{k.strftime("%m/%d")} => #{v}" }
  end
end