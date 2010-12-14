#!/usr/bin/env ruby
#-*-encoding: utf-8-*-
require_relative "../lib/month"
require_relative "../lib/year"

year, mon = ARGV.map(&:to_i)
if year && !mon
  cal = Caline::Year.new(year, holidays: :ja_ja)
  puts cal.color_format
else
  cal = Caline::Month.new(year, mon)
  cal.holidays = :ja_ja
  puts cal.color_format
end
