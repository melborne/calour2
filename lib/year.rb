#!/usr/bin/env ruby
#-*-encoding: utf-8-*-
require_relative "column"
module Caline
  class Year
    include Column
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
        three_column_form[@months, from, color]
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
  end
end