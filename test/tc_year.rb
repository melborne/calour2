require "test/unit"

require_relative "../lib/calour"

class TestYear < Test::Unit::TestCase
  def setup
    @y2010 = Calour::Year.new(2010)
  end

  def test_format_with_block_style
    y2010_from_monday = [
    "                              2010                              ",
    ["      January               February               March        ",
  " M  T  W  T  F  S  S   M  T  W  T  F  S  S   M  T  W  T  F  S  S",
  "             1  2  3   1  2  3  4  5  6  7   1  2  3  4  5  6  7",
  " 4  5  6  7  8  9 10   8  9 10 11 12 13 14   8  9 10 11 12 13 14",
  "11 12 13 14 15 16 17  15 16 17 18 19 20 21  15 16 17 18 19 20 21",
  "18 19 20 21 22 23 24  22 23 24 25 26 27 28  22 23 24 25 26 27 28",
  "25 26 27 28 29 30 31                        29 30 31            "],
  ["       April                  May                   June        ",
  " M  T  W  T  F  S  S   M  T  W  T  F  S  S   M  T  W  T  F  S  S",
  "          1  2  3  4                  1  2      1  2  3  4  5  6",
  " 5  6  7  8  9 10 11   3  4  5  6  7  8  9   7  8  9 10 11 12 13",
  "12 13 14 15 16 17 18  10 11 12 13 14 15 16  14 15 16 17 18 19 20",
  "19 20 21 22 23 24 25  17 18 19 20 21 22 23  21 22 23 24 25 26 27",
  "26 27 28 29 30        24 25 26 27 28 29 30  28 29 30            ",
  "                      31                    "],
  ["        July                 August              September      ",
  " M  T  W  T  F  S  S   M  T  W  T  F  S  S   M  T  W  T  F  S  S",
  "          1  2  3  4                     1         1  2  3  4  5",
  " 5  6  7  8  9 10 11   2  3  4  5  6  7  8   6  7  8  9 10 11 12",
  "12 13 14 15 16 17 18   9 10 11 12 13 14 15  13 14 15 16 17 18 19",
  "19 20 21 22 23 24 25  16 17 18 19 20 21 22  20 21 22 23 24 25 26",
  "26 27 28 29 30 31     23 24 25 26 27 28 29  27 28 29 30         ",
  "                      30 31                 "],
  ["      October               November              December      ",
  " M  T  W  T  F  S  S   M  T  W  T  F  S  S   M  T  W  T  F  S  S",
  "             1  2  3   1  2  3  4  5  6  7         1  2  3  4  5",
  " 4  5  6  7  8  9 10   8  9 10 11 12 13 14   6  7  8  9 10 11 12",
  "11 12 13 14 15 16 17  15 16 17 18 19 20 21  13 14 15 16 17 18 19",
  "18 19 20 21 22 23 24  22 23 24 25 26 27 28  20 21 22 23 24 25 26",
  "25 26 27 28 29 30 31  29 30                 27 28 29 30 31      "]
  ]

  y2010_from_sunday_with_color = [
  "        \e[33m    \e[0m                  \e[33m2010\e[0m                  \e[33m    \e[0m        ",
  "      \e[32mJanuary\e[0m               \e[32mFebruary\e[0m               \e[32mMarch\e[0m        ",
  " S  M  T  W  T  F  S   S  M  T  W  T  F  S   S  M  T  W  T  F  S",
  "                1 \e[36m 2\e[0m      1  2  3  4  5 \e[36m 6\e[0m      1  2  3  4  5 \e[36m 6\e[0m",
"\e[35m 3\e[0m  4  5  6  7  8 \e[36m 9\e[0m  \e[35m 7\e[0m  8  9 10 11 12 \e[36m13\e[0m  \e[35m 7\e[0m  8  9 10 11 12 \e[36m13\e[0m",
"\e[35m10\e[0m 11 12 13 14 15 \e[36m16\e[0m  \e[35m14\e[0m 15 16 17 18 19 \e[36m20\e[0m  \e[35m14\e[0m 15 16 17 18 19 \e[36m20\e[0m",
"\e[35m17\e[0m 18 19 20 21 22 \e[36m23\e[0m  \e[35m21\e[0m 22 23 24 25 26 \e[36m27\e[0m  \e[35m21\e[0m 22 23 24 25 26 \e[36m27\e[0m",
"\e[35m24\e[0m 25 26 27 28 29 \e[36m30\e[0m  \e[35m28\e[0m                    \e[35m28\e[0m 29 30 31         ",
"\e[35m31\e[0m                                          "
  ]
    assert_equal(y2010_from_monday, @y2010.format(:block, 1))
    y2010_color = @y2010.color_format(:block).join
    y2010_from_sunday_with_color.each { |line| assert_match(/#{Regexp.escape line}/, y2010_color) }
  end

  def test_fromat_with_line_style
    y2010_monochrome_line = ["2010",
    "January",
    " S  M  T  W  T  F  S  S  M  T  W  T  F  S  S  M  T  W  T  F  S  S  M  T  W  T  F  S  S  M  T  W  T  F  S ",
    "1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31",
    "February",
    "1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28",
    "March",
    "1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31",
    "April",
    "1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30",
    "May",
    "1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31",
    "June",
    "1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30",
    "July",
    "1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31",
    "August",
    " 1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31",
    "September",
    "1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30",
    "October",
    "1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31",
    "November",
    "1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30",
    "December",
    "1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31"]
    format = @y2010.format(:line).join
    y2010_monochrome_line.each { |line| assert_match(/#{line}/, format) }
  end

  def test_neighbor_option
    y2009 = [
    "\e[30m28\e[0m \e[30m29\e[0m \e[30m30\e[0m \e[30m31\e[0m  1  2 \e[36m 3\e[0m  \e[35m 1\e[0m  2  3  4  5  6 \e[36m 7\e[0m  \e[35m 1\e[0m  2  3  4  5  6 \e[36m 7\e[0m",
    "\e[35m18\e[0m 19 20 21 22 23 \e[36m24\e[0m  \e[35m22\e[0m 23 24 25 26 27 \e[36m28\e[0m  \e[35m22\e[0m 23 24 25 26 27 \e[36m28\e[0m", "\e[35m25\e[0m 26 27 28 29 30 \e[36m31\e[0m                        \e[35m29\e[0m 30 31 \e[30m 1\e[0m \e[30m 2\e[0m \e[30m 3\e[0m \e[30m 4\e[0m"
    ]
    format = Calour::Year.new(2009, neighbor: :black).color_format.join
    y2009.each { |line| assert_match(/#{Regexp.escape line}/, format) }
  end

  def test_holidays_names
    y = Calour::Year.new(2010, holidays: :ja_ja)
    puts y.color_format
  end
end
