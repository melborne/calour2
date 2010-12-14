#!/usr/bin/env ruby
#-*-encoding: utf-8-*-
require_relative 'month'
require_relative 'gcalendar'

module Caline
  class Year
    @@holidays = Hash.new{ |h, k| h[k] = {} }
    @@month_width = 20
    def initialize(year, opts={})
      @year = year
      @holidays = opts.delete(:holidays)
      @months = (1..12).map { |m| Caline::Month.new(@year, m, opts) }
    end
    
    alias formaty format
    def format(style=:week, from=0, color=false)
      out, year_label = [], nil
      case style
      when :week
        @months.each_slice(3) do |gr|
          left, center, right = gr.map do |mon|
            mon.holidays = @holidays if @holidays
            mon.format(:week, from, color)
          end
          left, center, right = align_size(left, center, right)
          year_label, *body = left.zip(center, right).map { |line| line.join("  ") }
          out << body
        end
        out.unshift year_label.sub(/(\d{4})(.+\d{4}.+)(\d{4})/, '    \2    ')
      when :month
        @months.each_with_index do |mon, i|
          mon.colors = {neighbor: :black}
          year_label, *body = mon.format(:month, from, color)
          out << body
        end
        out.unshift year_label
      end
    end

    def color_format(style=:week, from=0)
      format(style, from, true)
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

    def year_label(color)
      label = "#{@year}".center(@@month_width*3+4)
      color ? label.yellow : label
    end
    
  end
end