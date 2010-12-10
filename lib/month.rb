#!/usr/bin/env ruby
#-*-encoding: utf-8-*-
require "date"
require "term/ansicolor"
require_relative "gcalendar"

module Caline
  String.send(:include, Term::ANSIColor)

  class Month
    @@holidays = {}
    attr_reader :year, :month, :last, :colors
    def initialize(year, month, colors={})
      @year = year || Date.today.year
      @month = month || Date.today.mon
      @first = Date.new(@year, @month, 1)
      @last = last_date(@year, @month)
      @colors = { title: [:green,:yellow], today: [:green, :underline],
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

    def holidays(code=:ja_ja)
      @@holidays[@year] ||= GCalendar.new(@year).holidays(code)
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
          f = "%2d"
          f = case d
              when holiday?  then f.send(@colors[:holiday])
              when sunday?   then f.send(@colors[:sunday])
              when saturday? then f.send(@colors[:saturday])
              else f
              end
          f = today_format(f) if today?[d]
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

    def holiday?
      return nil unless @@holidays[@year]
      ->d{ @@holidays[@year].has_key?(d) }
    end

    def today_format(f)
      c = Array(@colors[:today])
      c.inject(f) { |mem, c| mem = mem.send(c) }
    end
  end
end

