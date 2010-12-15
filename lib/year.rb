#!/usr/bin/env ruby
#-*-encoding: utf-8-*-
require_relative "column"
module Caline
  class Year
    include ColumnForm
    def initialize(year, opts={})
      @year = year
      @holidays = opts.delete(:holidays)
      @months = (1..12).map { |m| Caline::Month.new(@year, m, opts) }
    end
    
    alias formaty format
    def format(style=:block, from=0, color=false, ho_name=true)
      out, year_label = [], nil
      case style
      when :block
        three_columns_formatter[@months, from, color, ho_name]
      when :line
        @months.each_with_index do |mon, i|
          mon.colors = {neighbor: :black}
          year_label, *body = mon.format(:line, from, color, ho_name)
          out << body
        end
        out.unshift year_label
      end
    end

    def color_format(style=:block, from=0, ho_name=true)
      format(style, from, true, ho_name)
    end
  end
end
