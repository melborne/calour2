#!/usr/bin/env ruby
#-*-encoding: utf-8-*-
require "optparse"
require "date"
Version = Calour::VERSION

module Calour::Runner
  OPTS = {style: :block, from:0, color:true, holidays: nil, footer:false}

  class << self
    def start
      parse_options
      mon, year = parse_argument ARGV.map(&:to_i)
      print_calendar(mon, year)
    end

    private
    def parse_options
      opt = OptionParser.new(colored_help)

      opt.on('-3')                { |v| OPTS[:style] = :block3 }
      opt.on('-l')                { |v| OPTS[:style] = :line }
      opt.on('-b')                { |v| OPTS[:style] = :block }
      opt.on('-m')                { |v| OPTS[:from] = 1 }
      opt.on('-s')                { |v| OPTS[:from] = 0 }
      opt.on('-n')                { |v| OPTS[:color] = false }
      opt.on('-k')                { |v| OPTS[:color] = true }
      opt.on('-c [COUNTRY_CODE]') { |v| v = v.sub(/^:/, '').intern unless v.nil?
                                        OPTS[:holidays] = v                      }
      opt.on('-t')                { |v| OPTS[:footer] = true }
      opt.on('-f')                { |v| OPTS[:footer] = false }
      opt.on('-y')                { |v| @y_opt = true }
      opt.on('-h', '--help')      { |v| puts colored_help; exit }

      opt.parse! ARGV rescue opt.parse! ['-h']
    end

    def help
      <<-EOS

NAME

  calour - displays a calendar with color

SYNOPSIS

  calour [-3lmnty] [-c [country_code]] [[month] year]

DESCRIPTION

  The options are as follows:

      -3         3 months block mode

      -l         line mode

      -b         block mode (default)

      -m         monday first

      -s         sunday first (default)

      -n         no color mode

      -k         color mode (default)

      -c country_code
                 holidays mark on/off. without country code, let it off.
                 acceptable code: ja us au ja_ja cn fr de it kr tw gb

      -t         append holiday titles

      -f         no holiday titles (default)

      -y         this year

      -h         display this help

      -v         display version

      EOS
    end

    def colored_help
      c = %w()
      help.gsub(/^[A-Z]+/) { $&.green }.gsub(/calour/) { $&.magenta.bold }.gsub(/-[\w\d]+/) { $&.cyan }
    end

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
      mon, year = nil, Date.today.year if @y_opt
      return mon, year
    end

    def print_calendar(mon, year)
      if year > 100 && !mon
        cal = Calour::Year.new(year, holidays: OPTS[:holidays])
        puts cal.format(OPTS[:style], OPTS[:from], OPTS[:color], OPTS[:footer])
      else
        cal = Calour::Month.new(year, mon)
        cal.holidays = OPTS[:holidays] if OPTS[:color]
        puts cal.format(OPTS[:style], OPTS[:from], OPTS[:color], OPTS[:footer])
      end
    end
  end
end

