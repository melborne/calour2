#!/usr/bin/env ruby
#-*-encoding: utf-8-*-
require_relative "../lib/month"
require "termcolor"

year, mon = ARGV.map(&:to_i)
m = Month.new(year, mon)
puts m.format
puts
puts m.format(1)
puts
puts m.format(1, false, false)
