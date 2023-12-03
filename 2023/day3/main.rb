require_relative "./input.rb"


#
# What is the sum of all of the part numbers in the engine schematic?
# this is horribly inefficient
#
class Part1
  attr_reader :valid_numbers

  def initialize(schematic_str)
    @str = schematic_str
    @valid_numbers = []
  end

  def run
    schematic_map.each_with_index do |line_arr, line_index|
      raw_num = []
      adjacent_symbol = false
      puts "#{line_index} of #{schematic_map.length - 1}"
      line_arr.each_with_index do |char, char_index|
        if char =~ /\d/
          raw_num << char
          #puts char
          adjacent_symbol = adjacent_symbol || adjacent_symbol?(line_index, char_index)
        end
        unless line_arr[char_index + 1] =~ /\d/
          @valid_numbers << raw_num.join.to_i if raw_num.any? && adjacent_symbol
          raw_num = []
          adjacent_symbol = false
        end
      end
    end
  end

  def sum_of_schematic
    valid_numbers.sum
  end

  def schematic_map
    schematic_map ||= @str.split("\n").map { |line| line.split("") }
  end

  def valid_index?(line_index, char_index)
    return false if line_index < 0 || line_index > (schematic_map.length - 1)
    return false if char_index < 0 || char_index > (schematic_map[0].length - 1)

    true
  end

  def adjacent_symbol?(line_index, char_index)
    (-1..1).each do |x_offset|
      (-1..1).each do |y_offset|
        next if x_offset == 0 && y_offset == 0
        x = line_index + x_offset
        y = char_index + y_offset

        #puts "    #{x},#{y}:"
        #puts "        #{valid_index?(x,y) && !schematic_map[x][y].match?(/(\d|\.)/)}"
        return true if valid_index?(x,y) && !schematic_map[x][y].match?(/(\d|\.)/)
      end
    end
    false
  end
end

#part1 = Part1.new(SCHEMATIC)
#part1.run
#puts part1.sum_of_schematic


#
# The inefficiency continues
#
# 82506572 is too low
#
class Part2

  def initialize(schematic_str)
    @str = schematic_str
    @map = {}
  end

  def run
    schematic_map.each_with_index do |line_arr, line_index|
      raw_num = []
      adjacent_stars = []
      puts "#{line_index} of #{schematic_map.length - 1}"
      line_arr.each_with_index do |char, char_index|
        if char =~ /\d/
          raw_num << char
          adjacent_stars = adjacent_stars.concat(adjacent_stars(line_index, char_index))
        end
        unless line_arr[char_index + 1] =~ /\d/
          if raw_num.any? && adjacent_stars.any?
            gear = raw_num.join.to_i
            #puts "gear: #{gear}, locations: #{adjacent_stars.uniq}"
            adjacent_stars.uniq.each { |location| add_to_map(location, gear) }
          end
          raw_num = []
          adjacent_stars = []
        end
      end
    end
  end

  def add_to_map(location, value)
    if @map[location]
      @map[location] << value
    else
      @map[location] = [value]
    end
  end

  def sum_of_gear_ratios
    @map.each_value.map do |gear_arr|
      if gear_arr.length == 2
        gear_arr[0] * gear_arr[1]
      else
        0
      end
    end.sum
  end

  def schematic_map
    schematic_map ||= @str.split("\n").map { |line| line.split("") }
  end

  def valid_index?(line_index, char_index)
    return false if line_index < 0 || line_index > (schematic_map.length - 1)
    return false if char_index < 0 || char_index > (schematic_map[0].length - 1)

    true
  end

  def adjacent_stars(line_index, char_index)
    locations = []
    (-1..1).each do |x_offset|
      (-1..1).each do |y_offset|
        next if x_offset == 0 && y_offset == 0
        x = line_index + x_offset
        y = char_index + y_offset
        valid = valid_index?(x,y) && schematic_map[x][y] == "*"

        #puts "    #{x},#{y}: #{valid}"
        locations << "#{x}:#{y}" if valid
      end
    end
    locations
  end
end

part2 = Part2.new(SCHEMATIC)
part2.run
puts part2.sum_of_gear_ratios
