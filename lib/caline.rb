#!/usr/bin/env ruby
#-*-encoding: utf-8-*-
require "date"
require "term/ansicolor"
require_relative 'month'
require_relative 'year'
require_relative "gcalendar"

module Caline
  String.send(:include, Term::ANSIColor)
  VERSION = '1.0'
end

