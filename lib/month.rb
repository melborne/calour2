#!/usr/bin/env ruby
#-*-encoding: utf-8-*-
require "date"

class Month
  attr_reader :year, :mon, :last
  def initialize(year, mon)
    @year = year || Date.today.year
    @mon = mon || Date.today.mon
    @first = Date.new(@year, @mon, 1)
    @last = last_date(@year, @mon)
  end

  def dates
    (@first..@last).to_a
  end
  
  def dates_by_week(from=0)
    pre = (1..(@first.wday-from)%7).map { |i| @first - i }.reverse
    pos = (1..(6-@last.wday+from)%7).map { |i| @last + i }
    (pre + dates + pos).each_slice(7).to_a
  end

  alias formaty format
  def format(style=:week, from=0)
    format_proc = ->w{ w.map{ |d| formaty "%2d ", d.day }.join }
    case style
    when :week
      dates_by_week(from).map { |w| format_proc[w] }.join("\n")
    when :month
      format_proc[dates]
    else raise ArgumentError
    end
  end

  private
  def last_date(year, mon, day=[28, 29, 30, 31])
    Date.new(year, mon, day.pop) rescue retry
  end

end

