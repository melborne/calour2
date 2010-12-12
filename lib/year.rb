#!/usr/bin/env ruby
#-*-encoding: utf-8-*-
require_relative 'month'
require_relative 'gcalendar'

module Caline
  class Year
    @@holidays = Hash.new{ |h, k| h[k] = {} }
    @@month_width = 20
    def initialize(year)
      @year = year
      @months = (1..12).map { |m| Caline::Month.new(@year, m, neighbor: nil) }
    end
    
    def holidays=(code)
      @code = code
      @@holidays[@year][@code] ||= Caline::GCalendar.new(@year).holidays(@code)
    end

    def holidays
      @@holidays[@year]
    end

    alias formaty format
    def format(style=:week, from=0, color=false)
      out = []
      @months.each_slice(3) do |gr|
        left, center, right = gr.map do |mon|
          mon.holidays=:ja_ja
          mon.color_format(:week, 0)[1..-1]
        end
        left, center, right = align_size(left, center, right)
        out << left.zip(center, right).map { |line| line.join("  ") }
      end
      year_label = "#{@year}".center(@@month_width*3+4).yellow
      out.unshift year_label
    end

    private
    def align_size(*args)
      max = args.map(&:size).max
      if args[0].size != max
        args[0] << " " * @@month_width
      end
      if args[1].size != max
        args[1] << " " * @@month_width
      end
      args
    end
    
  end
end