module Caline
  module Column
    def three_column_form
      lambda do |months, from, color|
        out, year_label = [], nil
        months.each_slice(3) do |gr|
          left, center, right = gr.map do |mon|
            mon.holidays = @holidays if @holidays
            mon.format(:week, from, color)
          end
          left, center, right = align_size(left, center, right)
          year_label, *body = left.zip(center, right).map { |line| line.join("  ") }
          out << body
        end
        out.unshift year_label.sub(/(\d{4})(.+\d{4}.+)(\d{4})/, '    \2    ')
      end
    end

    # align height size to max one
    def align_size(*args)
      max = args.map(&:size).max
      if args[0].size != max
        args[0] << " " * MONTH_WIDTH()
      end
      if args[1].size != max
        args[1] << " " * MONTH_WIDTH()
      end
      args
    end
  
    def MONTH_WIDTH
      20
    end
  end
end