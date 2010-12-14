#!/usr/bin/env ruby
#-*-encoding: utf-8-*-
require "optparse"
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

opt = OptionParser.new
OPTS = {style: :week, from:0, color:true, holidays: :ja_ja}

opt.on('-l') { |v| OPTS[:style] = :month }          # month line mode
opt.on('-b') { |v| OPTS[:style] = :week }           # week block mode(default)
opt.on('-m') { |v| OPTS[:from] = 1 }                # monday first
opt.on('-s') { |v| OPTS[:from] = 0 }                # sunday first(default)
opt.on('-n') { |v| OPTS[:color] = false }           # non-color mode
opt.on('-c') { |v| OPTS[:color] = true }            # color mode(default)
opt.on('-h VAL') { |v| OPTS[:holidays] = v.intern } # show holidays

opt.parse! ARGV

mon, year = parse_argument ARGV.map(&:to_i)

if year > 100 && !mon
  cal = Caline::Year.new(year, holidays: OPTS[:holidays])
  puts cal.format(OPTS[:style], OPTS[:from], OPTS[:color])
else
  cal = Caline::Month.new(year, mon)
  cal.holidays = OPTS[:holidays] if OPTS[:color]
  puts cal.format(OPTS[:style], OPTS[:from], OPTS[:color])
end

