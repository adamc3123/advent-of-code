require_relative "./input.rb"

TEST_GAMES = <<-TEXT
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
TEXT

# As far as the Elf has been able to figure out, you have to figure out which of
# the numbers you have appear in the list of winning numbers. The first match
# makes the card worth one point and each match after the first doubles the point
# value of that card.
class Part1
  def initialize(games_str)
    @games_str = games_str
    @points = 0
  end

  def run
    @games_str.split("\n").each do |game|
      my_nums,winnning_nums = game.split("|").map do |nums_str|
        parse_nums(nums_str)
      end
      my_nums.shift
      my_nums = my_nums.uniq
      points = matches_to_points(matches(my_nums, winnning_nums).length)
      #puts points
      @points += points
    end
    @points
  end

  def matches(my_nums, winning_nums)
    my_nums.select { |num| winning_nums.include?(num) }
  end

  def parse_nums(str)
    str.scan(/\d+/)
  end

  def matches_to_points(num_matches)
    num_matches.zero? ? 0 : 2**(num_matches-1)
  end
end

#puts Part1.new(TEST_GAMES).run
#puts Part1.new(GAMES).run


class Part2
  def initialize(games_str)
    @games_str = games_str
  end

  def run
    match_counts = initial_match_count_arr
    cards = Array.new(match_counts.count, 1)
    for index in 0...cards.count
      match_counts[index].times do |x|
        i = index + x + 1
        cards[i] += cards[index] if i < cards.count
      end
    end
    puts cards.to_s
    cards.sum
  end

  def initial_match_count_arr
    @games_str.split("\n").map do |game|
      my_nums,winnning_nums = game.split("|").map do |nums_str|
        parse_nums(nums_str)
      end
      my_nums.shift
      my_nums = my_nums.uniq
      match_count(my_nums, winnning_nums)
    end
  end

  def match_count(my_nums, winning_nums)
    my_nums.select { |num| winning_nums.include?(num) }.count
  end

  def parse_nums(str)
    str.scan(/\d+/)
  end
end

#puts Part2.new(TEST_GAMES).run
puts Part2.new(GAMES).run

