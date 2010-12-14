#!/usr/bin/env ruby
#-*-encoding: utf-8-*-
require_relative "../lib/month"
require_relative "../lib/year"

def parse_argument(args)
  mon, year = args.sort
  if mon.nil? && year.nil?
    mon, year = Date.today.mon, Date.today.year
  elsif year.nil?
    if mon >= 100
      mon, year = year, mon
    else
      year = Date.today.year
    end
  end
  return mon, year
end

mon, year, opt = parse_argument ARGV.map(&:to_i)

if year > 100 && !mon
  cal = Caline::Year.new(year, holidays: :ja_ja)
  puts cal.color_format
else
  cal = Caline::Month.new(year, mon)
  cal.holidays = :ja_ja
  puts cal.color_format
end

