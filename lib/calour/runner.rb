#!/usr/bin/env ruby
#-*-encoding: utf-8-*-
require "optparse"
require "date"
Version = Calour::VERSION

module Calour::Runner
  OPTS = {style: :block, from:0, color:true, holidays: nil, footer:false}
  @color_opts = {}

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
      opt.on('--color [COLOR_SET]')  { |v| parse_color v }

      opt.parse! ARGV rescue opt.parse! ['-h']
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

    def parse_color(args)
      h = args.split(/[, ]+/)
              .inject({}) { |h, arg| k, v = arg.split(':'); h[t_title k] = t_color(v.split('-')); h }
      @color_opts.update h
    end

    def t_title(key)
      %w(year month today saturday sunday holiday neighbor footer).detect { |t| t =~ /^#{key}/ }.intern
    end

    def t_color(values)
      values.inject([]) { |mem, val| mem << Term::ANSIColor.attributes.detect { |c| c =~ /^#{val}/ } }
    end

    def print_calendar(mon, year)
      if year > 100 && !mon
        opts = @color_opts.merge(holidays: OPTS[:holidays])
        cal = Calour::Year.new(year, opts)
        puts cal.format(OPTS[:style], OPTS[:from], OPTS[:color], OPTS[:footer])
      else
        cal = Calour::Month.new(year, mon, @color_opts)
        cal.holidays = OPTS[:holidays] if OPTS[:color]
        puts cal.format(OPTS[:style], OPTS[:from], OPTS[:color], OPTS[:footer])
      end
    end

    def colored_help
      attrs = Term::ANSIColor.attributes
      colors = (attrs*' ')[/bold.*on_white/].split(' ')
      help.gsub(/^[A-Z].*$/) { $&.green }
          .gsub(/calour/) { $&.split(//).map.with_index { |chr,i| chr.send colors[i+11] }.join.bold }
          .gsub(/\B-+[\w\d]+/) { $&.cyan }
          .gsub(/(?<=\s\s)\w+(?=:\s)/) { $&.cyan }
          .gsub(/(?<=\s)(#{colors.join('|')})(?=[,)\]\s])/) { $&.send $& }
    end

    def help
      <<-EOS

NAME

  calour - displays a calendar with color

SYNOPSIS

  calour [-3lmnty] [-c [country_code]] [--color color_set] [[month] year]

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

COLOR SETTINGS

  Colors can be changed with --color COLOR_SET option. COLOR_SET is constructed
  as combination of target-color-pairs.

      examples;

        --color year:magenta,today:on_green,holiday:red

        --color mon:yel,hol:blu,nei:bla

        --color 'sat:blue sun:red tod:blink'

        --color 'today:blue-on_yellow-blink'

  Like examples, each pairs are joined with ','(comma), target and color are
  joined with ':'(colon). each target accepts multi-color in which colors are
  joined with '-'(see 4th example). names of targets and colors can be reduced.

  Target names are as follows:

      year:       year label color (default: yellow)

      month:      month label color (default: green)

      today:      today date color (default: green, underline)

      saturday:   saturday dates color (default: cyan)

      sunday:     sunday dates color (default: magenta)

      holiday:    holiday dates color (default: red)

      neightbor:  neighbor months dates color (default: nil)

      footer:     holiday date and title colors at footer (default: green, yellow)

  Color names are as follows:

      black, red, green, yellow, blue, magenta, cyan, white,
      on_black, on_red, on_green, on_yellow, on_blue, on_magenta,
      on_cyan, on_white, bold, underline, blink 

      EOS
    end
  end
end

