#!/usr/bin/env ruby
#-*-encoding: utf-8-*-
require "date"
require "term/ansicolor"

String.send(:include, Term::ANSIColor)

class Month
  attr_reader :year, :mon, :last, :colors
  def initialize(year, mon, colors={})
    @year = year || Date.today.year
    @mon = mon || Date.today.mon
    @first = Date.new(@year, @mon, 1)
    @last = last_date(@year, @mon)
    @colors = { title: [:green,:yellow], today: :green,
                saturday: :cyan, sunday: :magenta, holiday: :red }
    @colors.update(colors)
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
  def format(style=:week, from=0, form=mono_proc)
    case style
    when :week
      dates_by_week(from).map { |w| form[w] }.join("\n")
    when :month
      form[dates]
    else raise ArgumentError
    end
  end

  def color_format(style=:week, from=0)
    format(style, from, color_proc)
  end

  def colors=(colors)
    @colors.update(colors)
  end

  private
  def last_date(year, mon, day=[28, 29, 30, 31])
    Date.new(year, mon, day.pop) rescue retry
  end

  def mono_proc
    ->w{ w.map{ |d| formaty "%2d", d.day }.join(" ") }
  end

  def color_proc
    ->w{
      w.map do |d|
        f = "%2d"
        f =
          case d
          when sunday?   then f.send(@colors[:sunday])
          when saturday? then f.send(@colors[:saturday])
          else f
          end
        f = f.send(@colors[:today]) if today?[d]
        
        formaty f, d.day
      end.join(" ")
    }
  end

  def sunday?
    ->d{ d.wday == 0 }
  end

  def saturday?
    ->d{ d.wday == 6 }
  end
  
  def today?
    ->d{ d == Date.today }
  end
end

