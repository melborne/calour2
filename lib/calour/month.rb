#-*-encoding: utf-8-*-
require_relative "column"

module Calour
  class Month
    include ColumnForm
    @@holidays = Hash.new{ |h, k| h[k] = {} }
    attr_reader :year, :month, :last, :colors

    def initialize(year, month, colors={})
      @year, @month = year, month
      @first = Date.new(@year, @month, 1)
      @last = last_date(@year, @month)
      @colors = { year: :yellow, month: :green, today: [:green, :underline], saturday: :cyan,
                  sunday: :magenta, holiday: :red, neighbor:nil, footer: [:green, :yellow] }
      @colors.update(colors)
      @code = nil
    end

    def dates(from=0, pre=true, pos=true)
      pre = pre ? (1..(@first.wday-from)%7).map { |i| @first - i }.reverse : []
      pos = pos ? (1..(6-@last.wday+from)%7).map { |i| @last + i } : []
      pre + (@first..@last).to_a + pos
    end
  
    def dates_by_block(from=0)
      dates(from).each_slice(7)
    end

    alias formaty format
    def format(style=:block, from=0, color=false, footer=false)
      formatter = color ? method(:color_formatter) : method(:mono_formatter)
      body =
        case style
        when :block
          header(from, color, :block) +
          dates_by_block(from).map { |aweek| formatter.call aweek }
        when :line
          header(from, color, :line) +
          Array( formatter.call dates )
        when :block3
          months = [self-1, self, self+1]
          three_columns_formatter(months, from, color)
        else raise ArgumentError
        end
      footer ? body + holiday_names(style==:block3 ? months : Array(self)) : body
    end

    def color_format(style=:block, from=0, footer=false)
      format(style, from, true, footer)
    end

    def colors=(colors)
      @colors.update(colors)
    end

    # need to set this before formatting
    def holidays=(code)
      if @code = code
        @@holidays[@year][@code] ||= GCalendar.new(@year).holidays(@code)
      end
    end

    def holidays
      @@holidays
    end

    def +(month)
      mon = @first.next_month(month)
      m = Month.new(mon.year, mon.mon, @colors)
      set_holiday_for_neighbor(m)
    end

    def -(month)
      mon = @first.prev_month(month)
      m = Month.new(mon.year, mon.mon, @colors)
      set_holiday_for_neighbor(m)
    end

    private
    # set holidays opt if base month has set holidays
    def set_holiday_for_neighbor(mon)
      if @@holidays[@year][@code]
        mon.holidays = @code; mon
      else
        mon
      end
    end

    def last_date(year, month, day=[28, 29, 30, 31])
      Date.new(year, month, day.pop) rescue retry
    end

    def mono_formatter(dates)
      dates.map do |d|
        str = "%2d"
        str = case d
              when neighbor? then str.replace "  "
              else str
              end
        formaty str, d.day
      end.join(" ")
    end

    def color_formatter(dates)
      dates.map do |d|
        str = "%2d"
        str = case d
              when neighbor?
                @colors[:neighbor] ? str.color(@colors[:neighbor]) : str.replace("  ")
              when holiday?  then str.color(@colors[:holiday])
              when sunday?   then str.color(@colors[:sunday])
              when saturday? then str.color(@colors[:saturday])
              else str
              end
        str = str.color(@colors[:today]) if today?[d]
        formaty str, d.day
      end.join(" ")
    end

    def sunday?
      ->d{ d.wday == 0 }
    end

    def saturday?
      ->d{ d.wday == 6 }
    end
  
    def today?
      ->d{ d == Date.today }
    end

    def holiday?
      return nil unless @@holidays[@year][@code]
      ->d{ @@holidays[@year][@code].has_key?(d) }
    end

    def neighbor?
      ->d{ d.mon != @month }
    end

    def header(from, color, style)
      weeks = week_label(from, style)
      year, month = %w(%Y %B).map { |f| @first.strftime(f).center(weeks.size) }
      if color
        year.sub!(/\d{4}/) { $&.color(@colors[:year]) }
        month.sub!(/\w+/) { $&.color(@colors[:month]) }
      end
      [year, month, weeks]
    end

    def week_label(from, style)
      weeks = " " + %w(S M T W T F S).rotate(from).join("  ")
      case style
      when :block then weeks
      when :line  then (weeks + " ") * 5
      end
    end

    def holiday_names(months)
      months.inject([]) { |mem, mon| 
        holidays = @@holidays[mon.year][@code]
        if holidays && !(selected = holidays.select { |d, _| d.mon == mon.month }).empty?
          mem << selected.sort_by { |d, _| d }
                         .map { |date, name|
                                date.strftime('%_m/%_d').color(@colors[:footer][0]) +
                                                ": " + name.color(@colors[:footer][1])
                         }.join
        else
          mem
        end
      }
    end
  end
end

