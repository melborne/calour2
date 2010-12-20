# -*- encoding:utf-8 -*-

class String
  def color(colors)
    _self = self.dup
    attrs = Term::ANSIColor.attributes - [:clear]
    colors = Array(colors).select { |color| attrs.include? color }
    colors.inject(_self) { |str, color| str.__send__ color }
  end
end

