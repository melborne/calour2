#!/usr/bin/env ruby
#-*-encoding: utf-8-*-
require "date"
require "term/ansicolor"
require_relative "gcalendar"

module Caline
  String.send(:include, Term::ANSIColor)

  class Month
    @@holidays = Hash.new{ |h, k| h[k] = {} }
    attr_reader :year, :month, :last, :colors

    def initialize(year, month, colors={})
      @year = year || Date.today.year
      @month = month || Date.today.mon
      @first = Date.new(@year, @month, 1)
      @last = last_date(@year, @month)
      @colors = { year: :yellow, month: :green, today: [:green, :underline],
                  saturday: :cyan, sunday: :magenta, holiday: :red, neighbor: :black }
      @colors.update(colors)
      @code = nil
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
    def format(style=:week, from=0, color=false)
      form = color ? color_proc : mono_proc
      case style
      when :week
        header(from, color) +
        dates_by_week(from).map { |w| form[w] }
      when :month
        form[dates]
      else raise ArgumentError
      end
    end

    def color_format(style=:week, from=0)
      format(style, from, true)
    end

    def colors=(colors)
      @colors.update(colors)
    end

    # need to set this before formatting
    def holidays=(code)
      @code = code
      @@holidays[@year][@code] ||= GCalendar.new(@year).holidays(@code)
    end

    private
    def last_date(year, month, day=[28, 29, 30, 31])
      Date.new(year, month, day.pop) rescue retry
    end

    def mono_proc
      ->w{ w.map{ |d| formaty "%2d", d.day }.join(" ") }
    end

    def color_proc
      ->w{
        w.map do |d|
          str = "%2d"
          str = case d
                when neighbor? then str.send(*@colors[:neighbor] || [:replace, "  "])
                when holiday?  then str.send(@colors[:holiday])
                when sunday?   then str.send(@colors[:sunday])
                when saturday? then str.send(@colors[:saturday])
                else str
                end
          str = today_format(str) if today?[d]
          formaty str, d.day
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

    def holiday?
      return nil unless @@holidays[@year][@code]
      ->d{ @@holidays[@year][@code].has_key?(d) }
    end

    def neighbor?
      ->d{ d.mon != @month }
    end

    def today_format(str)
      attrs = Array(@colors[:today])
      attrs.inject(str) { |s, color| s = s.send(color) }
    end

    def header(from, color)
      weeks = " " + %w(S M T W T F S).rotate(from).join("  ")
      year, month = %w(%Y %B).map { |f| @first.strftime(f).center(weeks.size) }
      if color
        year, month = year.send(@colors[:year]), month.send(@colors[:month])
      end
      [year, month, weeks]
    end
  end
end

