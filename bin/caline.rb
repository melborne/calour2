#!/usr/bin/env ruby
#-*-encoding: utf-8-*-
require_relative "../lib/month"
require_relative "../lib/year"
require "termcolor"

year, mon = ARGV.map(&:to_i)
unless mon
  year = year || Date.today.year
  cal = Caline::Year.new(year)
  puts cal.format
else
  cal = Caline::Month.new(year, mon)
  puts cal.format
end
