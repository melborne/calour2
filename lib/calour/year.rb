#!/usr/bin/env ruby
#-*-encoding: utf-8-*-
require_relative "column"
module Calour
  class Year
    include ColumnForm
    @@holidays = Hash.new{ |h, k| h[k] = {} }
    def initialize(year, opts={})
      @year = year
      @code = opts.delete(:holidays)
      @months = (1..12).map { |m| Calour::Month.new(@year, m, opts) }
      if @code
        @months.each { |m| m.holidays = @code }
        @@holidays[@year] = @months.first.holidays[@year]
      end
    end

    def holidays=(code)
      @months.first.holidays = @code = code
      @@holidays[@year] = @months.first.holidays[@year]
    end
    
    alias formaty format
    def format(style=:block, from=0, color=false, footer=false)
      body =
      case style
      when :block
        body = three_columns_formatter(@months, from, color)
      when :line
        out, year_label = [], nil
        @months.each do |mon|
          year_label, *body = mon.format(:line, from, color, false)
          out << body
        end
        out.unshift year_label
      end
      footer ? body + holiday_names(@months) : body
    end

    def color_format(style=:block, from=0, footer=false)
      format(style, from, true, footer)
    end

    private
    def holiday_names(months)
      holidays = @@holidays[@year][@code]
      if holidays
        out = []
        holidays.sort_by { |d, _| d }
                .map { |date, name| date.strftime('%_m/%_d').yellow + ": " + name.green }
                .each_slice(3) { |gr| out << gr.join }
        out
      else
        []
      end
    end
  end
end
