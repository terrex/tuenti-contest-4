#!/usr/bin/env ruby

# main.rb for Tuenti Contest 4th Challenge
#
# (C) 2014 Guillermo Gutierrez
#

$: << '.'
$: << './05-Tribblemaker.challenge'

require 'game_of_life'

class Cell

  def initialize(alive)
    @alive = !!alive
  end

  def to_s
    @alive ? 'X' : '-'
  end

end

class Game

  def initialize(width, height, map_file, steps)
    @width, @height, @steps = width, height, steps
    @cells = Array.new(height)
    0.upto(height - 1) do |y|
      row = map_file.readline.chomp
      @cells[y] = Array.new(width)
      0.upto(width - 1) do |x|
        @cells[y][x] = Cell.new(row[x] == 'X')
      end
    end
    @generations = [self.to_s]
  end

  def next_up_to_loop!
    while @generations.count < @steps do
      next!
      if other = @generations.index(self.to_s)
        puts "#{other} #{@generations.count - other}"
        break
      else
        @generations << self.to_s
      end
    end
  end

  def alive_neighbours(y, x)
    [[-1, 0], [1, 0], # sides
     [-1, 1], [0, 1], [1, 1], # over
     [-1, -1], [0, -1], [1, -1] # under
    ].inject(0) do |sum, pos|
      if (y + pos[0]) >= 0 && (y + pos[0]) < @height
        if (x + pos[1]) >= 0 && (x + pos[1]) < @width
          sum = sum + @cells[(y + pos[0])][(x + pos[1])].to_i
        end
      end

      sum
    end
  end

  def to_s
    @cells.map { |row| row.join }.join
  end
end


game = Game.new(8, 8, STDIN, 100)
game.next_up_to_loop!
