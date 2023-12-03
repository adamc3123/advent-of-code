require_relative "./main.rb"

TEST_INPUT = <<-TEXT
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
TEXT

TEST_INPUT2 = <<-TEXT
........897.......839...........651.399.............236...............................343...986...........308...............................
........*................*404......*............134.....953..508=.....................*....*..........325*..........744......392............
...350..847..403...-..541.....622.................*....................356.......%..95...793....................830...........*.....163.....
.....&.......@...105.............$..745............42...785.............*..443.412............922..............*...........663........*.....
.253....../..........696.............*..................*..............817.$.....................*...........62........................373..
...........244...419....*189....=........*...871.74...797...353.737................227..626.....429.726%...9......*956...803/.......*.......
TEXT
#[[897,847],[651,399],[343,95],[986,793],[308,325],[134,42],[404,541],[392,663],[163,373],[356,817],[830,62],[785,797],[922,429],[696,189]]

describe Part1 do
  describe "#run" do
    it "finds valid numbers in the input string" do
      subject = Part1.new("123*..\n..+456\n..6+..")
      subject.run
      expect(subject.valid_numbers).to include(123, 456, 6)
    end

    it "ignores invalid numbers" do
      subject = Part1.new("123*..\n6.....\n")
      subject.run
      expect(subject.valid_numbers).to eq([123])
    end

    it "accepts any symbol except for '.'" do
      subject = Part1.new("123+...456..")
      subject.run
      expect(subject.valid_numbers).to include(123)
    end

    it "finds all valid numbers in the provided test input" do
      subject = Part1.new(TEST_INPUT)
      subject.run
      expect(subject.valid_numbers).to include(467,35,633,617,592,755,664,598)
      expect(subject.valid_numbers.length).to eq(8)
    end
  end

  describe "#schematic_map" do
    it "creates a 2D character array" do
      subject = Part1.new("12..\n..45")
      expect(subject.schematic_map[0]).to include("1","2", ".", ".")
      expect(subject.schematic_map[1]).to include(".",".", "4", "5")
    end
  end

  describe "#valid_numbers" do
    it "returns an array" do
      subject = Part1.new("")
      expect(subject.valid_numbers).to be_instance_of(Array)
    end
  end

  describe "#sum_of_schematic" do
    it "returns the sum of valid_numbers" do
      subject = Part1.new("1+..2&....3*\n")
      subject.run
      expect(subject.sum_of_schematic).to eq(6)
    end

    it "returns the correct sum for the test input" do
      subject = Part1.new(TEST_INPUT)
      subject.run
      expect(subject.sum_of_schematic).to eq(4361)
    end
  end

  describe "#adjacent_symbol?" do
    it "is true if a symbol is found adjacent to the index" do
      subject = Part1.new("1+.%\n...2\n...3\n+4.!\n")
      expect(subject.adjacent_symbol?(0,0)).to be_truthy
      expect(subject.adjacent_symbol?(1,3)).to be_truthy
      expect(subject.adjacent_symbol?(2,3)).to be_truthy
      expect(subject.adjacent_symbol?(3,1)).to be_truthy
    end

    it "is false if a symbol is not found adjacent to the index" do
      subject = Part1.new("1+..\n....\n")
      expect(subject.adjacent_symbol?(1,3)).to be_falsey
    end
  end
end

describe Part2 do
  it "finds gears that have an adjacent star" do
    subject = Part2.new("123*456\n")
    subject.run
    expect(subject.sum_of_gear_ratios).to eq(123 * 456)
  end

  it "finds gears that have an adjacent star across rows" do
    subject = Part2.new("123...\n*.....\n456...")
    subject.run
    expect(subject.sum_of_gear_ratios).to eq(123 * 456)
  end

  it "returns the correct sum for the test input" do
    subject = Part2.new(TEST_INPUT)
    subject.run
    expect(subject.sum_of_gear_ratios).to eq(467835)
  end

  it "does not identify stars that have more than 2 adjacent gears" do
    subject = Part2.new("123...\n*111..\n456...")
    subject.run
    expect(subject.sum_of_gear_ratios).to eq(0)
  end

  it "does not identify stars that have only 1 adjacent gears" do
    subject = Part2.new("*123...\n......\n456...")
    subject.run
    expect(subject.sum_of_gear_ratios).to eq(0)
  end

  it "more tests" do
    subject = Part2.new("...*...\n238.236\n.......")
    subject.run
    expect(subject.sum_of_gear_ratios).to eq(238*236)
  end

  it "more tests 1" do
    subject = Part2.new(".22*...\n238.236\n.......")
    subject.run
    expect(subject.sum_of_gear_ratios).to eq(0)
  end

  it "more tests 2" do
    subject = Part2.new("...*...\n238.236\n.....**\n....111")
    subject.run
    expect(subject.sum_of_gear_ratios).to eq((238 * 236) + (236 * 111) + (236 * 111))
  end

  it "test input 2" do
    subject = Part2.new(TEST_INPUT2)
    subject.run
    expected_gears = [[897,847],[651,399],[343,95],[986,793],[308,325],[134,42],[404,541],[392,663],[163,373],[356,817],[830,62],[785,797],[922,429],[696,189]]
    expect(subject.sum_of_gear_ratios).to eq(expected_gears.map{|x| x.inject(:*)}.sum)
  end
end
