#!/usr/bin/env ruby
#-*-encoding: utf-8-*-
require "date"
require "term/ansicolor"

module Calour
  String.send(:include, Term::ANSIColor)
  VERSION = '1.0'
  def self.run
    Runner.start
  end
end

require_relative 'calour/month'
require_relative 'calour/year'
require_relative "calour/gcalendar"
require_relative "calour/runner"
