#!/usr/bin/env ruby
#-*-encoding: utf-8-*-
require "date"

class Month
  attr_reader :year, :mon, :last_day
  def initialize(year, mon)
    raise ArgumentError if year.nil? || mon.nil?
    @year, @mon = year, mon
    @init = Date.new(year, mon, 1)
    @last = last(year, mon)
    @days = (@init..@last).to_a
    @last_day = @last.day
  end
  
  def days
    @days.map(&:day)
  end

  def wd(day)
    case day
    when :first, :start, :begin then @init.wday
    when :last, :end            then @last.wday
    when Integer                then (@init+day-1).wday
    else raise ArgumentError
    end
  end

  def this_month?
    d = Date.today
    year == d.year && mon == d.mon
  end

  alias :formaty :format
  def format(from=0, week=true, fill=true)
    dayset = fill ? fill_week(@days.dup, from) : @days
    dayset.map do |d|
      f = (week && (d.wday-from)%7 == 6) ? "%2d\n" : "%2d "
      formaty f, d.day
    end.join
  end
  
  private
  def last(year, mon, day=[28, 29, 30, 31])
    Date.new(year, mon, day.pop) rescue retry
  end

  def fill_week(days, from)
    pre = (@init.wday - from) % 7
    suf = (6 - @last.wday + from) % 7
    pre.times { |d| days.unshift @init-d.next }
    suf.times { |d| days.push @last+d.next }
    days
  end
end
