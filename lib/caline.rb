#!/usr/bin/env ruby
#-*-encoding: utf-8-*-
require "date"
require "term/ansicolor"
require_relative "gcalendar"
require_relative 'month'
require_relative 'year'


module Caline
  String.send(:include, Term::ANSIColor)
end

