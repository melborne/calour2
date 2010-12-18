#!/usr/bin/env ruby
#-*-encoding: utf-8-*-
# Google Calendar Data API for retrieving holiday data
require "open-uri"
require "nokogiri"
require "cgi"
require "date"

module Calour
  class GCalendar
    def initialize(year, month=nil)
      @year, @month = year, month
    end
  
    def holidays(country=:ja_ja)
      parse_xml_to_hash get_holidays(country)
    end
  
    private
    def get_holidays(country)
      open URL(country) + PARAM(*build_date_range)
    rescue => e
      STDERR.puts "Failed to retrieve Holiday data by Google Calendar Data API. #{e}"
      STDERR.puts "Acceptable codes are: #{COUNTRY_ID().keys.join(" ")}"
    end

    def URL(country)
      "http://www.google.com/calendar/feeds/" +
              CGI.escape("#{COUNTRY_ID()[country]}") + "/public/full-noattendees?"
    end

    def COUNTRY_ID
      base1 = "@holiday.calendar.google.com"
      base2 = "#holiday@group.v.calendar.google.com"
      {
        ja: "japanese#{base1}",
        us: "usa__en#{base1}",
        au: "australian__en#{base1}",
        ja_ja: "ja.japanese#{base2}",
        cn: "en.china#{base2}",
        fr: "en.french#{base2}",
        de: "en.german#{base2}",
        it: "en.italian#{base2}",
        kr: "en.south_korea#{base2}",
        tw: "en.taiwan#{base2}",
        gb: "en.uk#{base2}"
       }
    end

    def PARAM(sd, ed)
      "start-min=#{sd}&start-max=#{ed}"
    end

    def build_date_range
      st, ed = @month ? [format("%02d", @month)] * 2 : ["01", "12"]
      return "#{@year}-#{st}-01", "#{@year}-#{ed}-31"
    end

    def parse_xml_to_hash(xml)
      data = Nokogiri::HTML(xml)
      h = {}
      data.css("entry").each do |node|
        date = node.css("gd", "when").attr("starttime").value
        h[Date.parse date] = node.css("title").text
      end
      h
    end
  end
end

if __FILE__ == $0
  g = Calour::GCalendar.new(2010, 9)
  p g.holidays
end
