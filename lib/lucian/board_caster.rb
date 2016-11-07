module Lucian
  module BoardCaster
    def self.print(message, color=nil)
      color_code = case color
      when "red"
        31
      when "green"
        32
      when "yellow"
        33
      when "blue"
        34
      when "pink"
        35
      when "cyan"
        36
      when "gray"
        37
      else
        0
      end
      puts "\e[#{color_code}m#{message}\e[0m"
    end
  end
end
