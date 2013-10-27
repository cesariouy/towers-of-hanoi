module TowerHanoi
  def play
    moves = 0

    valid_ans = false
    until valid_ans do
      puts "How many discs would you like? (1-99)"
      num_of_discs = gets.chomp.to_i
      if (num_of_discs > 0) && (num_of_discs < 100)
        valid_ans = true
      end
    end

    rods = []
    3.times {
      rods << Rod.new(num_of_discs + 1)
    }

    i = num_of_discs
    while i > 0 do
      rods[0].stack(Disc.new(i))
      i -= 1
    end

    goal = (2**(num_of_discs) - 1)
    header = "Moves: #{moves}\nPerfect Score: #{goal}"
    display(header, rods)

    until solved?(rods) do
      from = 0
      to = 0

      until [1,2,3].include?(from) do
        puts "Take the top disk from rod... (1, 2, or 3)"
        from = gets.chomp.to_i
      end
      from -= 1
      from_rod_val = rods[from].id_top_disc[0].value

      until [1,2,3].include?(to) do
        puts "and move it to..."
        to = gets.chomp.to_i
      end
      to -= 1
      to_rod_val = rods[to].id_top_disc[0].value

      if (from_rod_val <= to_rod_val) || (rods[to].empty?)
        move(rods[from], rods[to])
        moves += 1 if from_rod_val != 0
        header = "Moves: #{moves}\nPerfect Score: #{goal}"
      else
        header = "Can't place a larger disc on top of a smaller one!\n\nMoves: #{moves}\nPerfect Score: #{goal}"
      end

      display(header, rods)
    end

    header = "SOLVED in #{moves} moves\nPerfect Score: #{goal}"
    display(header, rods)
    if moves == goal
      puts "You won with a perfect score!\n\n"
    else
      puts "You won! Next time try to get a perfect score.\n\n"
    end

    return
  end

  def solved?(rods)
    rods[0].empty? && (rods[1].empty? || rods[2].empty?)
  end

  def display(header, rods)
    30.times {puts ""}
    puts header
    4.times {puts ""}

    i = rods[0].rod_status.count - 1
    until i < 0 do
      rods.each { |rod|
        print rod.rod_status[i].appearance
      }
      puts ""
      i -= 1
    end

    36.times {print "-"}
    puts "\n\n     1           2           3      "
    2.times {puts ""}
  end

  def move(from, to)
    to.stack(from.unstack)
  end

  class Rod
    attr_reader :rod_status

    def initialize(rod_length)
      @rod_status = []
      rod_length.times {
        @rod_status << Disc.new(0)
      }
    end

    def stack(disc)
      return @rod_status[0] = disc if self.empty?

      @rod_status[self.id_top_disc[1] + 1] = disc
    end

    def unstack
      temp = self.id_top_disc[0]
      @rod_status[self.id_top_disc[1]] = Disc.new(0)
      temp
    end

    def id_top_disc
      return [@rod_status[0], 0] if self.empty?

      i = 0
      until @rod_status[i+1].value == 0 do
        i += 1
      end
      [@rod_status[i], i]
    end

    def empty?
      @rod_status.each { |piece|
        return false if piece.value != 0
      }
      true
    end
  end

  class Disc
    attr_reader :value, :appearance

    def initialize(value)
      @value = value

      if @value == 0
        @appearance = "     ||     "
      elsif @value < 10
        @appearance = " [== 0#{value} ==] "
      else
        @appearance = " [== #{value} ==] "
      end
    end
  end
end

include TowerHanoi
loop {
  play
}
