#!/usr/local/bin/ruby
# -*- encoding:utf-8 -*-
require "test/unit"

require_relative "../lib/caline"

class TestMonth < Test::Unit::TestCase
  def setup
    @m = Caline::Month.new(2010, 12)
    @lasts2010 = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  end

  def test_last_day
    (1..12).each { |m| assert_equal(@lasts2010[m], Caline::Month.new(2010, m).last.day) }
  end

  def test_year_month
    assert_equal(2010, @m.year)
    assert_equal(12, @m.month)
  end

  def test_dates
    assert_equal((1..28).to_a, Caline::Month.new(2011, 2).dates(0, false, false).map(&:day))
    assert_equal((1..31).to_a, @m.dates(0, false, false).map(&:day))
    assert_equal([29, 30]+(1..31).to_a, @m.dates(1, true, false).map(&:day))
    assert_equal((1..31).to_a+[1], @m.dates(0, false, true).map(&:day))
    assert_equal([28, 29, 30]+(1..31).to_a+[1], @m.dates(0, true, true).map(&:day))
  end

  def test_dates_by_block
    f2010_12_from0 = [
      [28, 29, 30, 1, 2, 3, 4],
      [5, 6, 7, 8, 9, 10, 11],
      [12, 13, 14, 15, 16, 17, 18],
      [19, 20, 21, 22, 23, 24, 25],
      [26, 27, 28, 29, 30, 31, 1]
    ]
    f2010_12_from1 = [
      [29, 30, 1, 2, 3, 4, 5],
      [6, 7, 8, 9, 10, 11, 12],
      [13, 14, 15, 16, 17, 18, 19],
      [20, 21, 22, 23, 24, 25, 26],
      [27, 28, 29, 30, 31, 1, 2]
    ]
    assert_equal(f2010_12_from0, @m.dates_by_block.map{ |w| w.map(&:day) })
    assert_equal(f2010_12_from0, @m.dates_by_block(0).map{ |w| w.map(&:day) })
    assert_equal(f2010_12_from1, @m.dates_by_block(1).map{ |w| w.map(&:day) })
  end

  def test_monochrome_format
    f2010_12_from0 = [
      "        2010        ",
      "      December      ",
      " S  M  T  W  T  F  S",
      "          1  2  3  4",
      " 5  6  7  8  9 10 11",
      "12 13 14 15 16 17 18",
      "19 20 21 22 23 24 25",
      "26 27 28 29 30 31   "
    ]
    f2010_12_from1 = [
      "        2010        ",
      "      December      ",
      " M  T  W  T  F  S  S",
      "       1  2  3  4  5",
      " 6  7  8  9 10 11 12",
      "13 14 15 16 17 18 19",
      "20 21 22 23 24 25 26",
      "27 28 29 30 31      "
    ]
    f2010_12_from0_line = [
      "                                                  2010                                                   ",
      "                                                December                                                 ",
      " S  M  T  W  T  F  S  S  M  T  W  T  F  S  S  M  T  W  T  F  S  S  M  T  W  T  F  S  S  M  T  W  T  F  S ",
      "          1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31"
    ]
    assert_equal(f2010_12_from0, @m.format)
    assert_equal(f2010_12_from0, @m.format(:block, 0))
    assert_equal(f2010_12_from1, @m.format(:block, 1))
    assert_equal(f2010_12_from0_line, @m.format(:line))
  end
  
  def test_color_format
    f2010_12_from0_block = [
      "        \e[33m2010\e[0m        ",
      "      \e[32mDecember\e[0m      ",
      " S  M  T  W  T  F  S",
      "          1  2  3 \e[36m 4\e[0m",
      "\e[35m 5\e[0m  6  7  8  9 10 \e[36m11\e[0m",
      "\e[35m12\e[0m 13 14 15 \e[4m\e[32m16\e[0m\e[0m 17 \e[36m18\e[0m",
      "\e[35m19\e[0m 20 21 22 23 24 \e[36m25\e[0m",
      "\e[35m26\e[0m 27 28 29 30 31   "
    ]
    f2010_12_from1_block = [
      "        \e[33m2010\e[0m        ",
      "      \e[32mDecember\e[0m      ",
      " M  T  W  T  F  S  S",
      "       1  2  3 \e[36m 4\e[0m \e[35m 5\e[0m",
      " 6  7  8  9 10 \e[36m11\e[0m \e[35m12\e[0m",
      "13 14 15 \e[4m\e[32m16\e[0m\e[0m 17 \e[36m18\e[0m \e[35m19\e[0m",
      "20 21 22 23 24 \e[36m25\e[0m \e[35m26\e[0m",
      "27 28 29 30 31      "
    ]
    f2010_12_from1_line = [
      "                                                  \e[33m2010\e[0m                                                   ",
      "                                                \e[32mDecember\e[0m                                                 ",
      " M  T  W  T  F  S  S  M  T  W  T  F  S  S  M  T  W  T  F  S  S  M  T  W  T  F  S  S  M  T  W  T  F  S  S ",
      "       1  2  3 \e[36m 4\e[0m \e[35m 5\e[0m  6  7  8  9 10 \e[36m11\e[0m \e[35m12\e[0m 13 14 15 \e[4m\e[32m16\e[0m\e[0m 17 \e[36m18\e[0m \e[35m19\e[0m 20 21 22 23 24 \e[36m25\e[0m \e[35m26\e[0m 27 28 29 30 31"
    ]
    f2010_12_from0_block3 =[
      "        \e[33m    \e[0m                  \e[33m2010\e[0m                  \e[33m    \e[0m        ",
      ["      \e[32mNovember\e[0m              \e[32mDecember\e[0m              \e[32mJanuary\e[0m       ",
      " S  M  T  W  T  F  S   S  M  T  W  T  F  S   S  M  T  W  T  F  S",
      "    1  2  3  4  5 \e[36m 6\e[0m            1  2  3 \e[36m 4\e[0m                    \e[36m 1\e[0m",
      "\e[35m 7\e[0m  8  9 10 11 12 \e[36m13\e[0m  \e[35m 5\e[0m  6  7  8  9 10 \e[36m11\e[0m  \e[35m 2\e[0m  3  4  5  6  7 \e[36m 8\e[0m",
      "\e[35m14\e[0m 15 16 17 18 19 \e[36m20\e[0m  \e[35m12\e[0m 13 14 15 \e[4m\e[32m16\e[0m\e[0m 17 \e[36m18\e[0m  \e[35m 9\e[0m 10 11 12 13 14 \e[36m15\e[0m",
      "\e[35m21\e[0m 22 23 24 25 26 \e[36m27\e[0m  \e[35m19\e[0m 20 21 22 23 24 \e[36m25\e[0m  \e[35m16\e[0m 17 18 19 20 21 \e[36m22\e[0m",
      "\e[35m28\e[0m 29 30              \e[35m26\e[0m 27 28 29 30 31     \e[35m23\e[0m 24 25 26 27 28 \e[36m29\e[0m",
      "                                            \e[35m30\e[0m 31               "]
    ]
    assert_equal(f2010_12_from0_block, @m.color_format(:block, 0))
    assert_equal(f2010_12_from1_block, @m.color_format(:block, 1))
    assert_equal(f2010_12_from1_line, @m.color_format(:line, 1))
    assert_equal(f2010_12_from0_block3, @m.color_format(:block3))
  end
  
  def test_holidays
    day23 = /\e\[31m23\e\[0m/
    day3_23_1_10 = [' 3','23',' 1','10'].map { |d| /\e\[31m#{d}\e\[0m/ }
    titles = ['文化の日', '勤労感謝の日', '天皇誕生日', '元日', '成人の日']
    @m.holidays = :ja_ja
    assert_match(day23, @m.color_format.join )
    day3_23_1_10.each { |d| assert_match(d, @m.color_format(:block3).join) }
    titles.each { |t| assert_match(/#{t}/, @m.color_format(:block3).join) }
    titles.each { |t| refute_match(/#{t}/, @m.color_format(:block3, 0, false).join) }
    au_titles = ['Melbourne Cup Day', 'Christmas Day', 'Boxing Day', 'Public Holiday', 'Public Holiday', 'New Year\'s Day', 'Australia Day']
    @m.holidays = :au
    au_titles.each { |t| assert_match(/#{t}/, @m.color_format(:block3).join) }
  end

  def test_color_format_with_color_changes
    m = Caline::Month.new(2011, 2, sunday: :yellow, saturday: :green)
    colors = {12 => 32, 13 => 33}.map { |d, c| /\e\[#{c}m#{d}\e\[0m/ }
    colors.each { |c| assert_match(c, m.color_format(:line).join) }

    m = Caline::Month.new(2010, 12)
    m.holidays = :ja_ja
    colors = { year: :cyan, month: :red, today: [:blue, :on_yellow],
                saturday: :white, sunday: :black, holiday: :blue, neighbor: :black }
    m.colors = colors
    colors = {25 => 37, 26 => 30, 2010 => 36, 'December' => 31, 
                  16 => '43m\e\[34', 23 => 34, 30 => 30}.map { |d, c| /\e\[#{c}m#{d}\e\[0m/ }
    colors.each { |c| assert_match(c, m.color_format(:line).join) }
  end
end
